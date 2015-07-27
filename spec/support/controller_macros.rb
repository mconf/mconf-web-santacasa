# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2015 Mconf.
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

module ControllerMacros

  # Logs in with the user passed
  def login_as(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    user
  end

end
