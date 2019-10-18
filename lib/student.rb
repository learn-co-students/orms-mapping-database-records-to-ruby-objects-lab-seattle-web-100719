class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    database_born_student = Student.new
    database_born_student.id = row[0]
    database_born_student.name = row[1]
    database_born_student.grade = row[2]
    database_born_student
  end

  def self.all
    arr = []
    sql = "SELECT * FROM students"
    all_students_collection = DB[:conn].execute(sql)
    all_students_collection.each do |student_data_array|
      database_current_student = Student.new()
      database_current_student.id = student_data_array[0]
      database_current_student.name = student_data_array[1]
      database_current_student.grade = student_data_array[2]
      arr << database_current_student
    end
    arr
  end

  def self.first_X_students_in_grade_10(number)
    arr = []
    sql = "SELECT * FROM students WHERE students.grade = 10"
    found_student_data = DB[:conn].execute(sql)
    if found_student_data.size > number
        found_student_data = found_student_data[0..number-1]
    end

    found_student_data.each do |student_array|
      this_student = Student.new
      this_student.id = student_array[0]
      this_student.name = student_array[1]
      this_student.grade = student_array[2]
      arr << this_student
    end

    arr
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE students.grade = 10 ORDER BY students.id LIMIT 1"
    found_student_data = DB[:conn].execute(sql)[0]
    student_return = Student.new
    student_return.id = found_student_data[0]
    student_return.name = found_student_data[1]
    student_return.grade = found_student_data[2]
    student_return
  end

  def self.all_students_in_grade_X(grade)
    arr = []
    sql = "SELECT * FROM students WHERE students.grade = #{grade}"
    found_student_data = DB[:conn].execute(sql)
    
    found_student_data.each do |student_array|
      this_student = Student.new
      this_student.id = student_array[0]
      this_student.name = student_array[1]
      this_student.grade = student_array[2]
      arr << this_student
    end

    arr
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE students.name = ?"
    found_student_data = DB[:conn].execute(sql, name)[0]
    database_found_student = Student.new
    database_found_student.id = found_student_data[0]
    database_found_student.name = found_student_data[1]
    database_found_student.grade = found_student_data[2]
    database_found_student
  end

  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE students.grade = 9"
    found_student_data_collection = DB[:conn].execute(sql)
    found_student_data_collection.map do |student_data_array|
      database_found_student = Student.new
      database_found_student.id = student_data_array[0]
      database_found_student.name = student_data_array[1]
      database_found_student.grade = student_data_array[2]
    end
  end

  def self.students_below_12th_grade
    arr = []
    sql = "SELECT * FROM students WHERE students.grade < 12"
    found_student_data_collection = DB[:conn].execute(sql)
    found_student_data_collection.each do |student_data_array|
      database_found_student = Student.new()
      database_found_student.id = student_data_array[0]
      database_found_student.name = student_data_array[1]
      database_found_student.grade = student_data_array[2]
      arr << database_found_student
    end
    arr
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
