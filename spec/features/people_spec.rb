require "spec_helper"

feature "People" do
  scenario "follow and unfollow users" do

    user = Fabricate(:user)
    mark = Fabricate(:user, name: "Mark Jones")
    kelly = Fabricate(:user, name: "Kelly Jones")
    video1 = Fabricate(:video, title: "video1")
    video2 = Fabricate(:video, title: "video2")
    Fabricate(:review, user: mark, video: video1)
    Fabricate(:review, user: kelly, video: video2)

    sign_in(user)
    visit_video_and_follow_user(video1.slug, mark.name)
    visit_video_and_follow_user(video2.slug, kelly.name)
    expect(user.followed_users).to match_array([mark, kelly])

    visit people_path
    click_unfollow_user("Mark")
    expect(user.followed_users.count).to eq(1)

  end

end

def click_unfollow_user(user_name)
  find(:xpath, "//a[contains(@href,'#{user_name}')]").click
end