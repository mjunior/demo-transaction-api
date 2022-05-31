class Transaction < ApplicationRecord
  enum product: [:gasoline, :ethanol, :diesel]
end
