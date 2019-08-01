class Current < ActiveSupport::CurrentAttributes
  attribute :user
  attribute :request_uuid, :request_ip

  resets { Time.zone = nil }
end
