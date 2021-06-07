({
	doInit : function(component, event) {
		var relatedFile = component.get("v.relatedFile");
		component.set("v.lastModifiedDate", $A.localizationService.formatDate(relatedFile.ContentModifiedDate, "d-MMM-yyyy"));
		component.set("v.fileTypeIcon", this.getFileTypeIcon(relatedFile.FileType));

	},

	doPreview : function(component, event) {
		var fireEvent = $A.get("e.lightning:openFiles");
		fireEvent.fire({
			recordIds: [event.currentTarget.getAttribute("data-Id")]
		});
	},

	getFileTypeIcon : function(fileType) {
		if(fileType == "BMP"
		|| fileType == "GIF"
		|| fileType == "JPG"
		|| fileType == "PNG") {
			return "image";
		}
		
		if(fileType == "CSV") {
			return "csv";
		}
		
		if(fileType == "EXCEL" 
		|| fileType == "EXCEL_X") {
			return "excel";
		}

		if(fileType == "EXE") {
			return "exe";
		}
		
		if(fileType == "LINK") {
			return "link";
		}

		if(fileType == "MOV") {
			return "video";
		}

		if(fileType == "MP4") {
			return "mp4";
		}

		if(fileType == "PDF") {
			return "pdf";
		}
		
		if(fileType == "POWER_POINT"
		|| fileType == "POWER_POINT_X") {
			return "ppt";
		}

		if(fileType == "RTF") {
			return "rtf";
		}
		
		if(fileType == "TEXT") {
			return "txt";
		}
		
		if(fileType == "UNKNOWN") {
			return "unknown";
		}
		
		if(fileType == "VISIO") {
			return "visio";
		}
		
		if(fileType == "WORD"
		|| fileType == "WORD_X") {
			return "word";
		}

		if(fileType == "XML") {
			return "xml";
		}
		
		if(fileType == "ZIP") {
			return "zip";
		}
	}
})