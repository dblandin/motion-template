class Notice
  class << self
    def show(message = nil)
      hud_class.showWithStatus(message)
    end

    def loading
      show('Loading...')
    end

    def dismiss
      hud_class.dismiss
    end

    def image(image, message = nil)
      hud_class.showImage(image, status: message)
    end

    def success(message = '')
      hud_class.showSuccessWithStatus(message)
    end

    def error(message = '')
      hud_class.showErrorWithStatus(message)
    end

    def hud_class
      SVProgressHUD
    end
  end
end
