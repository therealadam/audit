source :gemcutter

gem "cassandra", :git => 'http://github.com/fauna/cassandra.git'
git "git://github.com/rails/rails.git", :tag => "v3.0.0_RC2" do
  gem "activemodel"
end

group :development do
  gem "activerecord", :git => "git://github.com/rails/rails.git", :tag => "v3.0.0_RC2"
  gem "sqlite3-ruby"
end

group :test do
  gem "shoulda"
  gem "nokogiri" # Cassandra::Mock needs this
end