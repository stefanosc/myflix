Fabricator(:payment) do
  amount            1
  stripe_payment_id "MyString"
  user_id           nil
end
