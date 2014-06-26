require 'spec_helper'

feature 'User browsing the website'  do
  context 'on homepage' do
    it "sees a list of recent posts titles" do
      question = Question.create(title: "BlahBlah", content: "More Blah", user_id: 1, category_id: 1)
      visit root_url
      expect(page).to have_content("BlahBlah")
    end

    it "when logged in should show user features" do
      @user = User.create(username: "pickles", email: "Ihatepicklesthefood@gmail.com", password: "notcake", password_confirmation: "notcake")
      page.set_rack_session(:user_id => @user.id)
      visit root_url
      expect(page).to have_content("Logout")
      expect(page).to have_content("Add Question")
      expect(page).to have_content("Profile")
    end

    it "should redirect to show page on click of question link" do
      question = Question.create(title: "BlahBlah", content: "More Blah", user_id: 1, category_id: 1)
      visit root_url
      click_link("BlahBlah")
      expect(page).to have_content("More Blah")
      expect(current_url).to eq question_url(question)
    end

    it 'should redirect to category page on click of browse' do
      visit root_url
      click_link("Browse")
      expect(current_url).to eq categories_url
    end

     it 'should redirect to add question when click add question' do
      @user = User.create(username: "pickles", email: "Ihatepicklesthefood@gmail.com", password: "notcake", password_confirmation: "notcake")
      page.set_rack_session(:user_id => @user.id)
      visit root_url
      click_link("Add Question")
      expect(current_url).to eq new_question_url
    end
    it 'should be logged out and redirected to homepage on click of logout' do
      @user = User.create(username: "pickles", email: "Ihatepicklesthefood@gmail.com", password: "notcake", password_confirmation: "notcake")
      page.set_rack_session(:user_id => @user.id)
      visit root_url
      click_link("Logout")
      expect(current_url).to eq questions_url
      expect(page.get_rack_session).to_not have_key("user_id")
    end
  end

  context 'on showpage and logged in' do
    before do
      @user = User.create(username: "pickles", email: "Ihatepicklesthefood@gmail.com", password: "notcake", password_confirmation: "notcake")
      page.set_rack_session(:user_id => @user.id)
      @question = Question.create(title: "BlahBlah", content: "More Blah", user_id: @user.id, category_id: 1)
      @question.answers << Answer.create(content: "You should do this...", user_id: @user.id)
      visit question_url(@question)
    end

    it 'should show the Add Answer button' do
      expect(page).to have_content("Add Answer")
    end
  end
end

