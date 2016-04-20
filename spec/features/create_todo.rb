require 'rails_helper'

describe "the todo creation process", type: :feature do
  before :each do
    user = User.new(email: 'user@example.com', password: 'password')
    user.confirm!
  end

  it "signs the user in and creates a todo" do
    visit '/users/sign_in'
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    expect(page).to have_content 'Add a todo!'
    fill_in 'Name', with: 'grocery shopping'
    click_button "Do it"
    expect(page).to have_content 'grocery shopping'
  end
end
