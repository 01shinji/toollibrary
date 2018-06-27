class Photo < ApplicationRecord
  belongs_to :listing



  has_attached_file :image, styles: { medium: "300x300#",  thumb: "100x100#" },  convert_options: { all: "-auto-orient" }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  



end
