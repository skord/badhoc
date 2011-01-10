# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require 'find'

Post.destroy_all

$images = []

def find_images
  Find.find('/Users/mike/Pictures/iPhoto Library') do |path|
    if File.basename(path) =~ /^\w.*.(jpg|png|gif)$/
      $images << path
    else
      next
    end
  end
end

find_images

def create_post(image)
  post = Post.new
  post.name= Faker::Name.first_name + "#" + Faker::Lorem.words(1)[0]
  post.subject= Faker::Lorem.sentence
  post.message= Faker::Lorem.paragraph(10)
  post.postpic= File.open(image)
  post.email= Faker::Internet.email
  post.client_ip= '127.0.0.1'
  post.save
end

for image in $images[1..150]
  create_post(image)
end