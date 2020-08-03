{% if theme.carousel.enable %}
<div id="carousel"> 
  <div width="100%" height="320px" style="margin-top: 15px; border: 0px; overflow: hidden; border-radius: 10px;" scrolling="no">
      <img src="{{theme.carousel.img}}"   style="width: 100%; height: 100%" ></img>
  </div>
  <br/>
  <div class="tag-cloud">
    <div class="tag-cloud-tags" id="tags">
      {{ tagcloud({min_font: 16, max_font: 16, amount: 300, color: true, start_color: '#fff', end_color: '#fff'}) }}
    </div>
  </div>
</div>
{% endif %}
