def create_tables_for_models
  ActiveRecord::Migration.verbose = false
  ActiveRecord::Schema.define do
    create_table :customers, force: true do |t|
      t.string :name
    end

    create_table :orders, force: true do |t|
      t.string :next_payload
      t.boolean :publishable
      t.integer :customer_id
    end

    create_table :test_sync_payloads, force: true do |t|
      t.text :body
      t.datetime  :generated_at
      t.integer   :subject_id
    end
  end
end

class Customer < ActiveRecord::Base
  has_many :orders
end

class Order < ActiveRecord::Base
  serialize :next_payload

  belongs_to :customer
end

module TestSync
  def self.table_name_prefix
    'test_sync_'
  end

  class Payload < ActiveRecord::Base
    serialize :body

    validates :generated_at, presence: true
    validates :subject_id, presence: true, uniqueness: true
  end
end
