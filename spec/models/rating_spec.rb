# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating, type: :model do
  it { should validate_presence_of :value }
  it { should validate_inclusion_of(:value).in_range(1..5) }
  it { should belong_to :book }
  it { should belong_to :user }
end
