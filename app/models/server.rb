class Server < ActiveRecord::Base
  attr_accessible :adminuser, :ip, :priority, :rootdir, :status
end
