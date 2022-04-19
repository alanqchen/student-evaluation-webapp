require 'rails_helper'

RSpec.describe User, type: :model do
  # Test random users can still be added to the db after tests
  after :all do
    create :user
    create :user, :admin
    create :user, :instructor
    create :user, :approver
    create :user, :instructor, :approver
    create :user, :admin, :approver
    create :user, :admin, :instructor
    create :user, :admin, :instructor, :approver
    create :user, :admin, :instructor, :student, :approver
  end

  before :each do
    @user = User.new name: "Test User", email: "user@test.com", password: "1Hash+salt", password_confirmation: "1Hash+salt", instructor: false, admin: false, student: true, approver: false
  end

  it 'has valid fields' do
    expect(@user).to be_valid
  end

  it 'is not valid with blank name' do
    @user.name = "    "
    expect(@user).to_not be_valid
  end

  it 'is not valid with blank email' do
    @user.email = "   "
    expect(@user).to_not be_valid
  end

  it 'is not valid with a too long name' do
    @user.name = "a" * 101
    expect(@user).to_not be_valid
  end

  it 'is not valid with a too long email' do
    @user.email = "a" * 244
    expect(@user).to_not be_valid
  end

  it 'is not valid with a badly formatted email address' do
    @user.email = "bad.email@"
    expect(@user).to_not be_valid
  end

  it 'is valid with a valid email address' do
    valid_emails = %w[user@TEST.com user@tEst one+two@www john.doe@foo.bar]
    valid_emails.each do |test_email|
      @user.email = test_email
      expect(@user).to be_valid
    end
  end

  it 'is not valid with duplicate email address' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    expect { @user.save }.to_not raise_error
    expect(duplicate_user).to_not be_valid
    # test db level error (model should downcase before save)
    expect { duplicate_user.save! validate: false }.to raise_error ActiveRecord::RecordNotUnique
  end

  it 'is not valid with a short password' do
    @user.password = "A+b1"
    expect(@user).to_not be_valid
  end

  it 'is not valid with no symbol in password' do
    @user.password = "Abcdefg1"
    expect(@user).to_not be_valid
  end

  it 'is not valid with no number in password' do
    @user.password = "Abcdefg+"
    expect(@user).to_not be_valid
  end

  it 'is not valid with no uppercase letter in password' do
    @user.password = "abcdefg1+"
    expect(@user).to_not be_valid
  end

  it 'is not valid with no lowercase letter in password' do
    @user.password = "ABCDEF1+"
    expect(@user).to_not be_valid
  end
end
