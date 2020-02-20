$(document).ready(function(){
	$(".x_panel").find(".x_content .kalender_kegiatan").on("click", function(){
		var self = $(this);
		$(location).attr("href","?year="+self.data('calendar').getYear());
	});
});

function editEvent(event) {
	var fulldate = event ? event.startDate : '';
	var month = fulldate.getMonth()+1;
	var day = fulldate.getDate();
	var date = (day < 10 ? '0' : '') + day +"-"+(month < 10 ? '0' : '')+month+"-"+fulldate.getFullYear();
	var month_grafik = (month < 10 ? '0' : '')+month;

	var dataSource =  $(".x_panel").find(".x_content .kalender_kegiatan").data('calendar').getDataSource();
	var ketemu = 0;
	var keterangan = '';
	for(var i in dataSource){
		if(dataSource[i].startDate.toLocaleDateString() == fulldate.toLocaleDateString()){
			ketemu = 1;
			keterangan = dataSource[i].name;
		}
	}

	$('#event-modal').modal('show');
	$("#event-modal").on('shown.bs.modal', function(){
		$("#event-modal").find(".modal-title").text("");
		$("#event-modal").find(".modal-body #tanggal_libur").val(date);
		$("#event-modal").find(".modal-body #data_kegiatan").attr("href","/kegiatan/index?dmy1="+date+"&dmy2="+date);
		$("#event-modal").find(".modal-body #grafik_kegiatan").attr("href","/kegiatan/grafik_kegiatan?my1="+month_grafik+"-"+fulldate.getFullYear()+"&tampilan=kategori");
		$("#event-modal").find(".modal-body #peta_kegiatan").attr("href","/kegiatan/peta_kegiatan?my1="+month_grafik+"-"+fulldate.getFullYear());
	});
}
