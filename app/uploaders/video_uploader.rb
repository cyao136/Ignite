=begin
# encoding: utf-8
require 'streamio-ffmpeg'
module CarrierWave
  module FFMPEG
    module ClassMethods
      def resample(bitrate)
        process :resample => bitrate
      end

      def gen_video_thumb(width, height)
        process :gen_video_thumb => [width, height]
      end
    end

    #def is_video?
    #  ::FFMPEG::Movie.new(File.open(store_path)).frame_rate != nil
    #end

    def gen_video_thumb(width, height)
      directory = File.dirname(current_path)
      tmpfile = File.join(directory, "tmpfile")

      FileUtils.move(current_path, tmpfile)
      file = ::FFMPEG::Movie.new(tmpfile)
      file.transcode(current_path, "-ss 00:00:01 -an -r 1 -vframes 1 -s #{width}x#{height}")

      FileUtils.rm(tmpfile)
    end

    def resample(bitrate)
      directory = File.dirname(current_path)
      tmpfile = File.join(directory, "tmpfile")

      FileUtils.move(current_path, tmpfile)

      file = ::FFMPEG::Movie.new(tmpfile)
      file.transcode(current_path, :audio_bitrate => bitrate)

      File.delete(tmpfile)
    end
  end
end

class VideoUploader < CarrierWave::Uploader::Base
  include CarrierWave::FFMPEG

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  process :resample => [1500]

  # Create different versions of your uploaded files:
  version :thumb do
    process :gen_video_thumb => [200, 150]
    process :convert => 'png'

    def full_filename for_file
      png_name for_file, version_name
    end

    def png_name for_file, version_name
      %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.png}
    end
  end

  def extension_white_list
    %w( avi mov mkv flv mp4 )
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
=end