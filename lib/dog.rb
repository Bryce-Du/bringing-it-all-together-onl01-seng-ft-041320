class Dog
    attr_accessor :id, :name, :breed

    def initialize (id: nil, name:, breed:)
        @id = id
        @name = name
        @breed = breed
    end

    def Dog.create_table
        DB[:conn].execute("CREATE TABLE dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT);")
    end
    def Dog.drop_table
        DB[:conn].execute("DROP TABLE dogs")
    end
    def Dog.new_from_db(row)
        Dog.new(id: row[0], name: row[1], breed: row[2])
    end
    def save
        sql = "INSERT INTO dogs (name, breed) VALUES (?, ?)"
        DB[:conn].execute(sql, self.name, self.breed)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
        self
    end
    def Dog.create(attributes)
        Dog.new(name: attributes[:name], breed: attributes[:breed]).save
    end
    def Dog.find_by_id(id)
        array = DB[:conn].execute("SELECT * FROM dogs WHERE id = #{id}")[0]
        Dog.new(id: array[0], name: array[1], breed: array[2])
    end
    def Dog.find_or_create_by(name:, breed:)
        dog = Dog.find_by_name(name)
        if dog.breed != breed
            dog.save
        end
        dog
    end
    def Dog.find_by_name(name)
        sql = "SELECT * FROM dogs WHERE name = ?"
        array = DB[:conn].execute(sql, name)[0]
        Dog.new(id: array[0], name: array[1], breed: array[2])
    end
    def update
        sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
        DB[:conn].execute(sql, @name, @breed, @id)
    end
end