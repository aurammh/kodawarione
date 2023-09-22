VALID_URL_REGEX = /\A(http|https):\/\/|[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,63}(:[0-9]{1,5})?(\/.*)?\z/ix

VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

INT_REGEX = /[0-9]/

VALID_ALPHANUMERIC_REGEX = /\A[a-z0-9]+\z/i

URL_VIDEO_ID = /(?:youtube(?:-nocookie)?\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/|vimeo\.com\/)([a-zA-Z0-9_-]{8,11})/

URL_VIDEO_PROV = /(youtube|youtu\.be|vimeo|drive\.google\.com)/

SPECIAL_CHAR_REGEX = /\W/