require "spec_helper"

feature "my_queue" do
  let(:user) { Fabricate(:user) }
  let(:admin) { Fabricate(:user, admin: true) }

  scenario "add video, add more videos and reorder" do
    category = Fabricate(:category)

    sign_in(admin)
    visit new_admin_video_path

    fill_and_submit_add_video_form category
    video = Video.last

    click_on "Welcome, #{admin.name}"
    click_on "Sign Out"

    sign_in(user)
    visit home_path
    expect(page).to have_xpath("//img[@src='#{video.small_cover_url}']")
    find(:xpath, "//a[@href='/videos/#{video.slug}']").click
    expect(page).to have_xpath("//img[@src='#{video.large_cover_url}']")
    expect(page).to have_xpath("//a[@href='#{video.video_url}']")
  end

end

def fill_and_submit_add_video_form category
  video_attrs = Fabricate.attributes_for(:video)
  fill_in "Title", with:  video_attrs[:title]
  select category.name, from:  "Category"
  fill_in "Description", with:  video_attrs[:description]
  attach_file 'Large Cover', "#{Rails.root}/public/tmp/monk_large.jpg"
  attach_file 'Small Cover', "#{Rails.root}/public/tmp/thor_dark_world.jpg"
  fill_in "Video url", with: "http://loveflix.s3.amazonaws.com/video/HW2%20Solution.mp4"
  click_on 'Add Video'
end
