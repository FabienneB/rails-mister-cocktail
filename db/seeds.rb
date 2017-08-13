# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Ingredient.create(name: "lemon")
# Ingredient.create(name: "ice")
# Ingredient.create(name: "mint leaves")
puts "tout début"
Dose.destroy_all
puts "début destruction cocktail"
Cocktail.destroy_all
puts "début destruction ingredients"
Ingredient.destroy_all

url = 'http://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
ingredient_serialized = open(url).read
ingredients = JSON.parse(ingredient_serialized)

puts "création ingredients"
ingredients["drinks"].each do |ingredient|
  ingredient_name = ingredient["strIngredient1"]
  Ingredient.create(name: ingredient_name)
end


# url = 'http://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Alcoholic'
# name_serialized = open(url).read
# names = JSON.parse(name_serialized)

# names["drinks"].each do |name|
#   cocktail_name = name["strDrink"]
#   my_cocktail = Cocktail.new(name: cocktail_name)
#   my_cocktail.photo_url = name["strDrinkThumb"]
#   my_cocktail.save
# end

url = 'http://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Alcoholic'
name_serialized = open(url).read
names = JSON.parse(name_serialized)
puts "Début créarion cocktail"
names["drinks"].first(20).each do |name|
  cocktail_name = name["strDrink"]
  my_cocktail = Cocktail.new(name: cocktail_name)
  my_cocktail.photo_url = name["strDrinkThumb"]
  my_cocktail.save
  my_id = name["idDrink"]
  puts "Fin de rééation cocktail"
  url = "http://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{my_id}"
  doses_serialized = open(url).read
  doses = JSON.parse(doses_serialized)
  puts "début de la création de la dose"
  doses["drinks"].each do |dose|
    my_ingredient = Ingredient.find_by_name(dose["strIngredient1"])
    dose_description = dose["strMeasure1"]
    my_dose = Dose.new(description: dose_description, ingredient: my_ingredient, cocktail: my_cocktail)
    my_dose.save
  end

end

# 100.times do
#   my_cocktail = Cocktail.new(name: Faker::Music.instrument)
#   my_cocktail.photo_url = Faker::LoremPixel.image
#   my_cocktail.save
# end



