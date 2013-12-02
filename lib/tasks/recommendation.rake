require 'recommendation_scheduler'
namespace :recommendation do


  desc "make a large calculation"
  task :calculate_all => :environment do
      scheduler = RecommendationScheduler.new
      scheduler.cal_all_potential_relation
      scheduler.cal_all_course_potential_customers
  end

  desc "make a large calculation for student"
  task :calculate_student => :environment do

    scheduler = RecommendationScheduler.new
    scheduler.cal_all_potential_relation

  end

  desc "make a large calculation for course"
  task :calculate_course  => :environment do
    scheduler = RecommendationScheduler.new
    scheduler.cal_all_course_potential_customers
  end

  desc "clear all the recommendation result"
  task :clear  => :environment do
    scheduler = RecommendationScheduler.new
    scheduler.init_persistence
    puts 'all result cleared'
  end

end