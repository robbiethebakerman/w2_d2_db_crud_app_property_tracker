require("pg")
class Property

  attr_accessor :address,  :value,  :number_of_bedrooms, :year_built, :buy_let_status,
  :square_footage, :build

  def initialize(options)
    @id = options["id"].to_i if options["id"].to_i
    @address = options["address"]
    @value = options["value"]
    @number_of_bedrooms = options["number_of_bedrooms"]
    @year_built = options["year_built"]
    @buy_let_status = options["buy_let_status"]
    @square_footage = options["square_footage"]
    @build = options["build"]

  end

  def save()
    db = PG.connect({dbname: "property_tracker", host: "localhost"})
    sql = "INSERT INTO property_listings (
      address,
      value,
      number_of_bedrooms,
      year_built,
      buy_let_status,
      square_footage,
      build
    )
    VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id;"
    values = [@address, @value, @number_of_bedrooms, @year_built, @buy_let_status, @square_footage, @build]
    db.prepare("save", sql)
    @id = db.exec_prepared("save", values)[0]["id"].to_i
    db.close()
  end

  def Property.all
    db = PG.connect({dbname: "property_tracker", host: "localhost"})
    sql = "SELECT * FROM property_listings"
    db.prepare("all", sql)
    properties = db.exec_prepared("all")
    db.close()
    return properties.map { |property| Property.new (property) }
  end

  def update()
    db = PG.connect( { dbname: "property_tracker", host: "localhost" } )
    sql = "UPDATE property_listings SET (
      address,
      value,
      number_of_bedrooms,
      year_built,
      buy_let_status,
      square_footage,
      build
    ) =
    ($1, $2, $3, $4, $5, $6, $7)
    WHERE id = $8"
    values = [@address, @value, @number_of_bedrooms, @year_built, @buy_let_status, @square_footage, @build, @id]
    db.prepare("update", sql)
    db.exec_prepared("update", values)
    db.close()
  end

  def Property.delete_all
    db = PG.connect({dbname: "property_tracker", host: "localhost"})
    sql = "DELETE FROM property_listings;"
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
    db.close()
  end

  def delete_one
    db = PG.connect({dbname: "property_tracker", host: "localhost"})
    sql = "DELETE FROM property_listings WHERE id = $1;"
    value = [@id]
    db.prepare("delete_one", sql)
    db.exec_prepared("delete_one", value)
    db.close()
  end

  def Property.find_by_id(id)
    db = PG.connect ( { dbname: "property_tracker", host: "localhost" } )
    sql = "SELECT * FROM property_listings WHERE id = $1;"
    value = [id]
    db.prepare("find", sql)
    listings = db.exec_prepared("find", value)[0]
    db.close()
    property = Property.new(listings)
    return property
  end

  def Property.find_by_address(address)
    db = PG.connect ( { dbname: "property_tracker", host: "localhost" } )
    sql = "SELECT * FROM property_listings WHERE address = $1;"
    value = [address]
    db.prepare("find", sql)
    listings = db.exec_prepared("find", value)[0]
    db.close
    property = Property.new(listings)
    return property
  end

end
