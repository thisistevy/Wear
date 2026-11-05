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
puts "#{User.count} users ont été créé(es)"

puts 'creating brands'
brand1 = Brand.create!(name: "Angarde", description: "Angarde revisit the timelessness of footwear to give them more meaning.", address: "69 Rue d'Aboukir, 75002 Paris", website: "https://www.angarde.fr", certifications: ["Vegan", "Fabriqué en Europe"])
brand2 = Brand.create!(name: "Thinking Mu", description: "Thinking MU is a sustainable clothing project.", address: "42 rue du chemin, 75011 Paris", website: "https://thinkingmu.com", certifications: ["GOTS", "Coton bio"])
brand3 = Brand.create!(name: "Brava Fabrics", description: "Modern, conscious, fair: Brava Fabrics believe in a sustainable future.", address: "24 Rue de Sèvres, 75007 Paris", website: "https://www.bravafabrics.com", certifications: ["Coton bio"])
brand4 = Brand.create!(name: "Le Petit Faon", description: "Solidarit clothing made of natural or recycled fibres.", address: "51-53 Rue Sainte-Catherine, 33000 Bordeaux", website: "https://lepetitfaon.fr", certifications: ["Recyclé", "Fabriqué en France"])
brand5 = Brand.create!(name: "Veja", description: "Since 2005, VEJA has been producing trainers differently with a positive impact at every stage of production.", address: "87 Quai des Queyries, 33100 Bordeaux", website: "https://www.veja-store.com", certifications: ["Vegan", "Commerce équitable"])
brand6 = Brand.create!(name: "Patagonia", description: "Patagonia makes high-performance, durable outdoor clothing and equipment.", address: "48 Bd Haussmann, 75009 Paris", website: "https://www.patagonia.com", certifications: ["Fair Trade", "Recyclé"])
brand7 = Brand.create!(name: "Armedangels", description: "Armedangels thinks organic. Armedangels believes fairness is never out of fashion.", address: "15 rue Chauchat, 33100 Bordeaux", website: "https://www.armedangels.com", certifications: ["GOTS", "Fair Wear"])
brand8 = Brand.create!(name: "D.Franklin®", description: "Urban brand combining current trends with the details of its materials.", address: "2 Rue de la Ferronnerie, 75001 Paris", website: "https://www.dfranklin.es", certifications: ["Vegan"])
puts "#{Brand.count} brands ont été créé(es)"

puts 'creating collection points'
CollectionPoint.create!(name: "Point de collecte Angarde", address: "69 Rue d'Aboukir, 75002 Paris", point_type: "collecte", brand: brand1, description: "Dépose de chaussures usagées pour recyclage.")
CollectionPoint.create!(name: "Relais Textile Bordeaux", address: "87 Quai des Queyries, 33100 Bordeaux", point_type: "collecte", brand: brand5, description: "Collecte de vêtements et chaussures de toutes marques.")
CollectionPoint.create!(name: "Centre de recyclage textile Paris 2e", address: "10 Rue Réaumur, 75002 Paris", point_type: "recyclage", description: "Point de recyclage municipal pour textiles non réutilisables.")
CollectionPoint.create!(name: "Relais Recyclage Bordeaux Centre", address: "15 rue Chauchat, 33100 Bordeaux", point_type: "recyclage", brand: brand7, description: "Recyclage de fibres textiles en fin de vie.")
puts "#{CollectionPoint.count} collection points ont été créé(es)"

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
puts "#{Product.count} products ont été créé(es)"

puts 'creating feedback'
Feedback.create!(user: user4, product: product9, purchase_date: Date.new(2022, 5, 8), comment: 'Very nice shoes, conformable and long lasting. I still wear them today.', rating: 5, wash_resistance: 4, wear_over_time: 5)
Feedback.create!(user: user2, product: product9, purchase_date: Date.new(2023, 8, 12), comment: "I've been wearing them for 1 year (almost every day) and they still look great.", rating: 4, wash_resistance: 4, wear_over_time: 4)
Feedback.create!(user: user3, product: product9, purchase_date: Date.new(2024, 2, 3), comment: 'Sneaker with fresh and light colours! A quality trainer.', rating: 3, wash_resistance: 3, wear_over_time: 3)
puts "#{Feedback.count} feedbacks ont été créé(es)"

puts 'creating listings'
Listing.create!(user: user1, title: "Veste en jean vintage", description: "Portée quelques fois seulement, taille M, très bon état général.", price: 25, condition: "très bon état", category: "Veste", gender: "Woman", listing_type: "vente")
Listing.create!(user: user2, title: "Pull en laine recyclée", description: "Un peu bouloché mais encore très chaud, taille L.", price: 12, condition: "bon état", category: "Pull", gender: "Man", listing_type: "vente")
Listing.create!(user: user3, title: "Baskets Veja taille 42", description: "Données car trop petites pour moi, jamais portées.", price: 0, condition: "neuf", category: "Sneakers", gender: "Man", listing_type: "don")
Listing.create!(user: user4, title: "Robe d'été à échanger", description: "Contre une robe taille 38, état neuf, portée une fois.", price: nil, condition: "neuf", category: "Robe", gender: "Woman", listing_type: "échange")
puts "#{Listing.count} listings ont été créé(es)"
