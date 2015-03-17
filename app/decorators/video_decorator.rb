class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    if reviews.any?
      "rating #{average_rating} / 5.0"
    else
      "Be the first one to review"
    end
  end

  def average_rating
    reviews.average(:rating).to_f.round(1)
  end
end
