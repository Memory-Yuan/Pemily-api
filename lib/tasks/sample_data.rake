namespace :db do
    desc "Fill database with sample data"
    task populate: :environment do
        make_users
    end
  
    def make_users
        admin = User.create!(
            email:                  "memory@qq.qq",
            password:               "qqqqqqqq",
            password_confirmation:  "qqqqqqqq"
        )
    end
    
end