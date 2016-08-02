$(document).ready ->
  #This function disables buttons when needed

  disableButtons = (counter_max, counter_current) ->
    $('#show-previous-image, #show-next-image').show()
    if counter_max == counter_current
      $('#show-next-image').hide()
    else if counter_current == 1
      $('#show-previous-image').hide()
    return

  ###*
  #
  # @param setIDs        Sets IDs when DOM is loaded. If using a PHP counter, set to false.
  # @param setClickAttr  Sets the attribute for the click handler.
  ###

  loadGallery = (setIDs, setClickAttr) ->
    current_image = undefined
    selector = undefined
    counter = 0

    updateGallery = (selector) ->
      $sel = selector
      current_image = $sel.data('image-id')
      $('#gallery-modal-caption').text $sel.data('caption')
      $('#gallery-modal-title').text $sel.data('title')
      if $sel.data('image')?
      	$('#gallery-modal-image').attr 'src', $sel.data('image')
      	$('#gallery-modal-image').attr 'hidden', false
      	$('#gallery-modal-video').attr 'hidden', true

      if $sel.data('video')?
      	$('#gallery-modal-video').attr 'src', $sel.data('video')
      	$('#gallery-modal-image').attr 'hidden', true
      	$('#gallery-modal-video').attr 'hidden', false

      disableButtons counter, $sel.data('image-id')
      return

    $('#show-next-image, #show-previous-image').click ->
      if $(this).attr('id') == 'show-previous-image'
        current_image--
      else
        current_image++
      selector = $('[data-image-id="' + current_image + '"]')
      updateGallery selector
      return
    if setIDs == true
      $('[data-image-id]').each ->
        counter++
        $(this).attr 'data-image-id', counter
        return
    $(setClickAttr).on 'click', ->
      updateGallery $(this)
      return
    return

  loadGallery true, 'a.thumbnail'
  return