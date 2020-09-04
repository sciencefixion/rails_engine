# Dione's Comments:
# Be sure to create the migrations for the tables otherwise you will get errors that those table don't exists yet and the rake file is unable to run.
# I like how reusbale you made your code by looping through the key value pairs of the hash
# Great job implementing the primary key reset for each table too. This is important since we are pulling the ids from the csv and we are not letting the database autogenerate those ids for us

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

# The commented out code below is unnecessary sense at the start of the file we are dropping and then creating the database so there isn't any data to be cleared
    # puts 'Database is being cleared...'
    # csv_file_data.values.each(&:destroy_all)
    # puts 'Database reset, data has been destroyed'

    puts 'CSV data is importing...'
    csv_file_data.each do |k, v|
      options = { value_converters: { unit_price: CentsToDollars }, headers: true }
      SmarterCSV.process(k, options) do |row|
        v.create!(row)
      end
    end

    puts 'Database successfully seeded with information from CSV files'

    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.reset_pk_sequence!(table)
    end
  end
end
