# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# NOTE (local dev): image/avatar attachment calls are skipped here on purpose —
# this environment only has dummy Cloudinary "demo" credentials (no real upload
# key), so any .attach call would fail. Re-enable them once real Cloudinary
# credentials are configured.
require 'date'

Feedback.destroy_all
Listing.destroy_all
CollectionPoint.destroy_all
Product.destroy_all
Brand.destroy_all
User.destroy_all

puts 'creating users'
test_user = User.create!(admin: true, username: "Testeur", email: "test@test.com", password: "password123")
user1 = User.create!(admin: true, username: "Titi", email: "romain@gmail.com", password: "1234567")
user2 = User.create!(admin: true, username: "Mattéo", email: "matteo@gmail.com", password: "1234567")
user3 = User.create!(admin: false, username: "Baptiste", email: "baptiste@gmail.com", password: "1234567")
user4 = User.create!(admin: true, username: 'Robin', email: 'robin@gmail.com', password: '1234567')
user5 = User.create!(admin: true, username: 'Cassandre', email: 'cassandre@gmail.com', password: '1234567')
puts "#{User.count} users were created"

puts 'creating brands'
brand1 = Brand.create!(name: "Angarde", description: "Angarde revisit the timelessness of footwear to give them more meaning.", address: "69 Rue d'Aboukir, 75002 Paris", website: "https://www.angarde.fr", certifications: ["Vegan", "Made in Europe"], buys_secondhand: true)
brand2 = Brand.create!(name: "Thinking Mu", description: "Thinking MU is a sustainable clothing project.", address: "42 rue du chemin, 75011 Paris", website: "https://thinkingmu.com", certifications: ["GOTS", "Organic cotton"])
brand3 = Brand.create!(name: "Brava Fabrics", description: "Modern, conscious, fair: Brava Fabrics believe in a sustainable future.", address: "24 Rue de Sèvres, 75007 Paris", website: "https://www.bravafabrics.com", certifications: ["Organic cotton"])
brand4 = Brand.create!(name: "Le Petit Faon", description: "Solidarit clothing made of natural or recycled fibres.", address: "51-53 Rue Sainte-Catherine, 33000 Bordeaux", website: "https://lepetitfaon.fr", certifications: ["Recycled", "Made in France"], buys_secondhand: true)
brand5 = Brand.create!(name: "Veja", description: "Since 2005, VEJA has been producing trainers differently with a positive impact at every stage of production.", address: "87 Quai des Queyries, 33100 Bordeaux", website: "https://www.veja-store.com", certifications: ["Vegan", "Fair trade"], buys_secondhand: true)
brand6 = Brand.create!(name: "Patagonia", description: "Patagonia makes high-performance, durable outdoor clothing and equipment.", address: "48 Bd Haussmann, 75009 Paris", website: "https://www.patagonia.com", certifications: ["Fair Trade", "Recycled"], buys_secondhand: true)
brand7 = Brand.create!(name: "Armedangels", description: "Armedangels thinks organic. Armedangels believes fairness is never out of fashion.", address: "15 rue Chauchat, 33100 Bordeaux", website: "https://www.armedangels.com", certifications: ["GOTS", "Fair Wear"])
brand8 = Brand.create!(name: "D.Franklin®", description: "Urban brand combining current trends with the details of its materials.", address: "2 Rue de la Ferronnerie, 75001 Paris", website: "https://www.dfranklin.es", certifications: ["Vegan"])
puts "#{Brand.count} brands were created"

puts 'creating collection points'
CollectionPoint.create!(name: "Angarde Collection Point", address: "69 Rue d'Aboukir, 75002 Paris", point_type: "collection", brand: brand1, description: "Drop off your worn shoes for recycling.")
CollectionPoint.create!(name: "Bordeaux Textile Hub", address: "87 Quai des Queyries, 33100 Bordeaux", point_type: "collection", brand: brand5, description: "Collects clothes and shoes from any brand.")
CollectionPoint.create!(name: "Paris 2nd Textile Recycling Centre", address: "10 Rue Réaumur, 75002 Paris", point_type: "recycling", description: "Municipal recycling point for non-reusable textiles.")
CollectionPoint.create!(name: "Bordeaux Centre Recycling Hub", address: "15 rue Chauchat, 33100 Bordeaux", point_type: "recycling", brand: brand7, description: "Recycling of end-of-life textile fibres.")
puts "#{CollectionPoint.count} collection points were created"

puts 'creating products'
product1 = Product.create!(brand_id: brand1.id, name: "After-surf cactus", category: "Sneakers", gender: "Woman", description: "An ultra-comfortable trainer, made of recycled materials and handmade in Portugal", environment: 40, labor: 35, animal: 100, composition: 40, barcode: "1000000000017")
product2 = Product.create!(brand_id: brand2.id, name: "Love T-Shirt", category: "T-Shirt", gender: "Woman", description: "White printed T-shirt in organic cotton - love", environment: 80, labor: 0, animal: 100, composition: 10, barcode: "1000000000024")
product3 = Product.create!(brand_id: brand2.id, name: "Turkana Top", category: "T-Shirt", gender: "Woman", description: "White T-shirt in organic cotton", environment: 80, labor: 0, animal: 100, composition: 10, barcode: "1000000000031")
product4 = Product.create!(brand_id: brand3.id, name: "Flannel Shirt", category: "Shirt", gender: "Man", description: "Blue grey organic cotton flannel shirt", environment: 80, labor: 0, animal: 100, composition: 20, barcode: "1000000000048")
product5 = Product.create!(brand_id: brand3.id, name: "Willys Adventure", category: "Shirt", gender: "Man", description: "Printed shirt regular fit hand-crafted.", environment: 80, labor: 0, animal: 100, composition: 20, barcode: "1000000000055")
product6 = Product.create!(brand_id: brand4.id, name: "Sunset Vibes", category: "T-Shirt", gender: "Woman", description: "Women's Sunset T-shirt in organic cotton.", environment: 70, labor: 40, animal: 100, composition: 60, barcode: "1000000000062")
product7 = Product.create!(brand_id: brand4.id, name: "Sweat-shirt Tom", category: "Sweat-shirt", gender: "Man", description: "Men's Sweat-Shirt in organic cotton and recycled polyester.", environment: 60, labor: 60, animal: 90, composition: 70, barcode: "1000000000079")
product8 = Product.create!(brand_id: brand2.id, name: "Save The Human T-Shirt", category: "T-Shirt", gender: "Man", description: "Men's sleeve T-shirt in organic cotton - Collaboration with protest press.", environment: 70, labor: 70, animal: 60, composition: 65, barcode: "1000000000086")
product9 = Product.create!(brand_id: brand5.id, name: "Esplar Chromefree", category: "Sneakers", gender: "Man", description: "Named after the Brazilian NGO we have been working with since 2005.", environment: 85, labor: 75, animal: 70, composition: 65, barcode: "1000000000093")
product10 = Product.create!(brand_id: brand5.id, name: "Suede Multico", category: "Sneakers", gender: "Woman", description: "The V-10 model is made of a combination of ecological and sustainable materials, symbolising 10 years of love.", environment: 85, labor: 75, animal: 70, composition: 65, barcode: "1000000000109")
product11 = Product.create!(brand_id: brand8.id, name: "One Way Multi UV", category: "Sneakers", gender: "Woman", description: "The limited edition One Way is inspired by the most casual of D.Franklin® collections.", environment: 45, labor: 60, animal: 80, composition: 50, barcode: '5000112558265')
puts "#{Product.count} products were created"

puts 'creating feedback'
Feedback.create!(user: user4, product: product9, purchase_date: Date.new(2022, 5, 8), comment: 'Very nice shoes, conformable and long lasting. I still wear them today.', rating: 5, wash_resistance: 4, wear_over_time: 5)
Feedback.create!(user: user2, product: product9, purchase_date: Date.new(2023, 8, 12), comment: "I've been wearing them for 1 year (almost every day) and they still look great.", rating: 4, wash_resistance: 4, wear_over_time: 4)
Feedback.create!(user: user3, product: product9, purchase_date: Date.new(2024, 2, 3), comment: 'Sneaker with fresh and light colours! A quality trainer.', rating: 3, wash_resistance: 3, wear_over_time: 3)
puts "#{Feedback.count} feedbacks were created"

puts 'creating listings'
Listing.create!(user: user1, title: "Vintage denim jacket", description: "Only worn a few times, size M, overall very good condition.", price: 25, condition: "very good condition", category: "Jacket", gender: "Woman", listing_type: "sale")
Listing.create!(user: user2, title: "Recycled wool jumper", description: "Slightly bobbled but still very warm, size L.", price: 12, condition: "good condition", category: "Jumper", gender: "Man", listing_type: "sale")
Listing.create!(user: user3, title: "Veja sneakers size 42", description: "Giving them away as they are too small for me, never worn.", price: 0, condition: "new", category: "Sneakers", gender: "Man", listing_type: "gift")
Listing.create!(user: user4, title: "Summer dress to swap", description: "Looking for a size 38 dress in exchange, as new, worn once.", price: nil, condition: "new", category: "Dress", gender: "Woman", listing_type: "swap")
puts "#{Listing.count} listings were created"
