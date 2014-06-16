require "spec_helper"

feature "my_queue" do
  let(:user) { Fabricate(:user) }

  scenario "add video, add more videos and reorder" do
    video1 = Fabricate(:video, title: "video1")
    video2 = Fabricate(:video, title: "video2")
    video3 = Fabricate(:video, title: "video3")

    sign_in(user)
    visit home_path
    find(:xpath, "//a[@href='/videos/video1']").click
    click_on "+ My Queue"
    visit queue_items_path
    expect(page).to have_content "video1"

    click_on "video1"
    expect(page).to have_content "video1"
    expect(page).not_to have_content "+ My Queue"

    visit home_path
    find(:xpath, "//a[@href='/videos/video2']").click
    click_on "+ My Queue"
    visit home_path
    find(:xpath, "//a[@href='/videos/video3']").click
    click_on "+ My Queue"
    visit queue_items_path
    all('#queue_items__position')[1].set('4')
    click_on "Update Instant Queue"
    expect(page.body.index(video1.title)).to be < page.body.index(video3.title)
    expect(page.body.index(video3.title)).to be < page.body.index(video2.title)
  end

end