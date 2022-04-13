# frozen_string_literal: true

require 'rails_helper'

STATUSES = %w[booking reading wish].freeze

RSpec.describe Post, type: :model do
  it { should validate_presence_of :title }
  it { should validate_inclusion_of(:title).in_array(STATUSES) }
  it { should belong_to :book }
  it { should belong_to :user }
end
