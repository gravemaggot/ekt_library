class FilterBooks
  attr_accessor :initial_scope

  QUANTITY_INDEX = 8
  DATA_LIST = { booking: ['booking', true],
                reading: ['reading', true],
                readed: ['reading', false],
                wishes: ['wish', false] }.freeze
  CHARACTER = { new: [], popular: [], top: [], commented: [] }.freeze

  def initialize(initial_scope, current_user, params)
    @initial_scope = initial_scope
    @current_user = current_user
    @params = params
    @filter = @params[:filter].to_sym
    @pagination = {}
  end

  def call(params)
    if index_scope?
      return_arr_by_character
    else
      # by filters
      books = @filter.nil? || @params[:filter] == '' ? initial_scope : filter!
      # by categories
      books = @params[:category_ids].nil? ? books : by_categories!(books)
      # sorting
      books = sort(books)
      # pagination
      paginate(books)
    end
  end

  def meta
    puts '**********************************************************************'
    puts @pagination
    puts '**********************************************************************'
    { pagination: @pagination }
  end

  private

  def index_scope?
    CHARACTER.keys.include?(@filter)
  end

  def filter!
    if DATA_LIST.keys.include?(@filter)
      # @current_user.posts.send(filter).map(&:book)
      return_filtered_arr_by_posts(DATA_LIST[@filter][0], DATA_LIST[@filter][1])
    else
      initial_scope.search(@filter)
    end
  end

  def by_categories!(scope)
    categories = @params[:category_ids]
    scope.joins(:categories).where(categories: { id: categories })
  end

  def sort(scope)
    return scope if @params[:sortBy].blank?

    @pagination[:sortBy] = @params[:sortBy]
    @pagination[:descending] = @params[:descending] || 'false'

    attributes = Book.column_names
    sort = @pagination[:sortBy]
    descending = @pagination[:descending]

    scope = if attributes.include?(sort) && sort != 'number_of' # TODO: destroy != 'number_of'
              scope.order(sort => (descending == 'true' ? :desc : :asc))
            else
              scope.sort_by(&sort.to_sym).reverse
            end
  end

  def paginate(scope)
    @pagination[:rowsNumber] = scope.count
    @pagination[:page] = @params[:page].to_i || 1
    @pagination[:rowsPerPage] = @params[:rowsPerPage] || 10
    Kaminari.paginate_array(scope).page(@pagination[:page]).per(@pagination[:rowsPerPage])
    # scope.page(@pagination[:page]).per(@pagination[:rowsPerPage])
  end

  def return_filtered_arr_by_posts(title, active)
    initial_scope.joins(:posts).where(posts: { title: title, user: @current_user, active: active })
  end

  def return_arr_by_character
    case @filter
    when :new
      new
    when :popular
      popular
    when :top
      top
    when :commented
      commented
    else
      # type code here
    end
  end

  def new
    filter_by_method(initial_scope, :created_at)
  end

  def popular
    books = initial_scope.joins(:posts).where(posts: { title: 'reading', active: false })
    filter_by_method(books, :calculate_readed)
  end

  def top
    books = initial_scope.joins(:ratings).where.not(ratings: nil)
    filter_by_method(books, :calculate_rating)
  end

  def commented
    books = initial_scope.joins(:comments).where.not(comments: nil)
    filter_by_method(books, :calculate_commented)
  end

  # def books_scope(joins_table, condition)
  #   initial_scope.joins(joins_table).where(joins_table: condition)
  # end

  def filter_by_method(scope, method)
    scope.sort_by { |item| item.send(method) }.uniq.last(QUANTITY_INDEX)
  end
end
