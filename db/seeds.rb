# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# default admin user
admin = User.create name: 'admin', email: 'admin@admin', password: 'Admin_123', password_confirmation: 'Admin_123', admin: true, instructor: false, student: false, approver: true, activated: true
student = User.create name: 'student', email: 'alanchen1908@gmail.com', password: 'Student_1', password_confirmation: 'Student_1', admin: false, instructor: false, student: true, approver: false, activated: false
student = User.create name: 'student', email: 'student2@student', password: 'Student_1', password_confirmation: 'Student_1', admin: false, instructor: false, student: true, approver: false, activated: false
student = User.create name: 'student', email: 'student3@student', password: 'Student_1', password_confirmation: 'Student_1', admin: false, instructor: false, student: true, approver: false, activated: true
student = User.create name: 'student', email: 'student4@student', password: 'Student_1', password_confirmation: 'Student_1', admin: false, instructor: false, student: true, approver: false, activated: true
