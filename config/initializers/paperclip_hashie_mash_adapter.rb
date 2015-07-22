module Paperclip
  class HashieMashUploadedFileAdapter < AbstractAdapter
    # attr_accessor :original_filename # use this accessor if you have paperclip version < 3.3.0

    def initialize(target)
      @tempfile, @content_type, @size = target.tempfile, target.type, target.tempfile.size
      self.original_filename = target.filename
    end

  end
end

Paperclip.io_adapters.register Paperclip::HashieMashUploadedFileAdapter do |target|
  target.is_a? Hashie::Mash
end