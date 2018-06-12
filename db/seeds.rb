users = []
10.times do
  users << "#{Faker::Name.first_name}@gmail.com"
end

users.uniq!

users.each do |user|
  User.create(email: user, login: user.slice(/\w+(?=@)/),
              password: "password", password_confirmation: "password")
end

10.times do
  zip_first = format("%.2d", rand(100))
  zip_second = format("%.3d", rand(1000))
  
  User.all
      .sample
      .events
      .create(name: Faker::App.name,
              address: { city: Faker::Address.city,
                        street: Faker::Address.street_name,
                        house_number: rand(100),
                        zip_code: "#{zip_first}-#{zip_second}" })
end

ITEMS = [
          { 
          name: "White Karate Gi",
          price: 110, 
          description: "Very light material for great mobility. High quality. Mesh-Inlets for best ventilation. WKF Approved. 60% Cotton : 40% Polyester", 
          store_item_id: 300912,
          size: "m"
          },
          {
          name: "Red Karate Sparring Mitts with Thumb",
          price: 60, 
          description: "Stylish and top quality. Absorbing foam, controlled density. PU cover. Fingers are held with elasticated loops for comfortable, safe & secure sparring. Velcro strap around wrist. Large padded strike area. ",
          store_item_id: 300913,
          size: "l"
          },
          {
          name: "Blue Karate Shin Foot Protector WKF Approved",
          price: 200, 
          description: "WKF Approved. Removable foot protector attached with two all around elastic straps for a firm, secure closing. Full length shin pads guard your shin all the way down to the top of your foot, to provide the ultimate protection. Injection moulded foam padded shin part and instep. CE Approved",
          store_item_id: 300914,
          size: "s"
          },
          {
          name: "Makiwara",
          price: 105, 
          description: "Foam padding on natural wood base. Covered with leather like material. Spring loaded. Secured to the wall with three dowel hooks",
          store_item_id: 300915,
          size: "m"
          },
          {
          name: "Round Chrome Metal Sai 19.5 inch",
          price: 195, 
          description: "Enables the practitioner to train with deadly speed and accuracy. Monouchi (shaft) of the sai is octagonal with an imitation leather handle. Practice training aid only and should not be used for full contact training. Damage incurred through misuse of this item is the responsibility of the customer. Sold in pairs",
          store_item_id: 300916,
          size: "m"
          },
          {
          name: "Blitz Swiftlock Smash Board",
          price: 110, 
          description: "Yellow = New Starter. Orange = Beginner. Green = Intermediate. Red = Advanced. Colours interchangeable to change strength levels",
          store_item_id: 300917,
          size: "m"
          },
          {
          name: "Bytomic Budo Wall Mounted Belt Display Rack",
          price: 325, 
          description: "Wall mountable display stand for showing off your martial arts belt achievements. Calligraphy 武道 translates to 'Budo' - the Martial Way. Belts not included. Fixings included",
          store_item_id: 300918,
          size: "m"
          },
          {
          name: "Dipped Foam Head Guard",
          price: 90, 
          description: "Single overlay foam. Foam sections above the ears are elevated to strengthen the margin of safety. Open face contour design for a good fit and visibility. Ventilation holes around the head guard. Fast closing with an elastic strap. CE Approved",
          store_item_id: 300919,
          size: "m"
          },
          {
          name: "Gel Shock Wrap Gloves",
          price: 48, 
          description: "Black neoprene with 10mm gel padded knuckles. Red neoprene top. 300cm long black stretchable wrap sewn to the palm of the glove. Velcro closing.",
          store_item_id: 300920,
          size: "m"
          },
          {
          name: "Groin Guard",
          price: 35, 
          description: "Elasticated material. Reinforced removable nylon cup. Cup edged with soft rubber for comfort. CE Approved.",
          store_item_id: 300920,
          size: "m"
          },
        ]
ITEMS.each { |item| Item.create(item) }

def generate_address
  Address.new(city: Faker::Address.city,
              street: Faker::Address.street_address,
              house_number: rand(1..100),
              zip_code: rand(50_000..99_999).to_s)
end

EVENTS = [{
            name: "2016 European Karate Championship",
            user: User.all.sample,
            description: "As Karate continues reaching new heights, we look |
            forward to an anticipated annual European Karate Championships. |
            Last year the 2017 European Championships were a sound success in |
            terms of sportsmanship and participation of athletes, with nearly |
            500 competitors from 43 countries taking part at the event and 17 |
            nations claiming medals in the competition.",
            date: Date.new(2019, 1, 19),
            address: generate_address
          },
          {
            name: "WKF Karate Kumite 2017",
            user: User.all.sample,
            description: "Initiated in 2011 with two tournaments held in |
            Barcelona and London, the WKF Karate Kumite has made exponential |
            progress in terms of magnitude and status of the tournaments as |
            well as the number of participants and countries represented.",
            date: Date.new(2019, 1, 25),
            address: generate_address
          },
          {
            name: "Continental Championships",
            user: User.all.sample,
            description: "23rd EKF Senior Championships, Novi Sad, Serbia,|
            Feb 10-13",
            date: Date.new(2019, 2, 10),
            address: generate_address
          },
          {
            name: "14th AKF Senior Championships",
            user: User.all.sample,
            description: "We invite you to participate in contest on April 11 |
            2019 in Sports Hall in Astana. Categories in competitions: kata, |
            kumite, kata and kumite team. Competitions in terms from six years |
            to the competitions for seniors.",
            date: Date.new(2019, 4, 11),
            address: generate_address
          },
          {
            name: "Karate 1 - Premier League Madrid 2019",
            user: User.all.sample,
            description: "On behalf of the Spanish Karate-do Federation I |
            would like to welcome you to the WKF Karate1 Premier League |
            tournament, also known as the Spanish Open. This fantastic |
            tournament will again take place in Madrid and will be held on |
            the 3rd, 4th and 5th of June 2018.",
            date: Date.new(2019, 6, 3),
            address: generate_address
          }]

EVENTS.each { |ev| Event.create!(ev) }
