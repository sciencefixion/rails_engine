namespace :db_seed_from_csv do
  desc 'seed db with CSV file data'
  task csv_db_seed: :environment do
    require 'smarter_csv'
    require './app/modules/cents_to_dollars'

    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute

    csv_file_data = {
      'db/data/customers.csv' => Customer,
      'db/data/merchants.csv' => Merchant,
      'db/data/items.csv' => Item,
      'db/data/invoices.csv' => Invoice,
      'db/data/invoice_items.csv' => InvoiceItem,
      'db/data/transactions.csv' => Transaction
    }

    puts 'Database is being cleared...'
    csv_file_data.values.each(&:destroy_all)
    puts 'Database reset, data has been destroyed'

    puts 'CSV data is importing...'
    csv_file_data.each do |k, v|
      options = { value_converters: { unit_price: CentsToDollars }, headers: true }
      SmarterCSV.process(k, options) do |row|
        object.create!(row)
      end
    end



    puts 'Database successfully seeded with information from CSV files'

    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.reset_pk_sequence!(table)
    end
  end
end
