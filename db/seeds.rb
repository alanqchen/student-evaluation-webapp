# default users
admin = User.create name: 'admin', email: 'admin@admin', password: 'Admin_123', password_confirmation: 'Admin_123', admin: true, instructor: false, student: false, approver: true, activated: true
student = User.create name: 'student 1', email: 'student1@student', password: 'Student_1', password_confirmation: 'Student_1', admin: false, instructor: false, student: true, approver: false, activated: true
student = User.create name: 'student 2', email: 'student2@student', password: 'Student_2', password_confirmation: 'Student_2', admin: false, instructor: false, student: true, approver: false, activated: true
student = User.create name: 'student 3', email: 'student3@student', password: 'Student_3', password_confirmation: 'Student_3', admin: false, instructor: false, student: true, approver: false, activated: true
student = User.create name: 'student 4', email: 'student4@student', password: 'Student_4', password_confirmation: 'Student_4', admin: false, instructor: false, student: true, approver: false, activated: true
instructor = User.create name: 'instructor 1', email: 'instructor1@instructor.edu', password: 'Instructor_1', password_confirmation: 'Instructor_1', admin: false, instructor: true, student: false, approver: false, activated: true
instructor = User.create name: 'instructor 2', email: 'instructor2@instructor.edu', password: 'Instructor_2', password_confirmation: 'Instructor_2', admin: false, instructor: true, student: false, approver: false, activated: true
