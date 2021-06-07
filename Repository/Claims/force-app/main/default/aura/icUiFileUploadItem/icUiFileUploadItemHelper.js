/**
 * Created by Francois Poirier on 2019-11-20.
 */
({
    doInit : function (component, event) {
        var file = component.get("v.file");
        component.set("v.fileName", file.name);
        component.set("v.fileId", file.documentId);
    },
    onDeleteFile : function (component, event){

        try{
            var file = component.get("v.file");

            var files = component.get("v.files");
            var fileIndex = component.get("v.index");
            files.splice(fileIndex, 1);

            var numberOfFiles = files.length;
            console.log("___________file length  :" + numberOfFiles);
            component.set("v.hasFullFile", false);
            component.set("v.fileNumber", numberOfFiles);
            console.log("___________file number  :" + numberOfFiles);
            if( numberOfFiles == 0){
                component.set("v.sendBtnIsDisabled", true);
            }
            component.set("v.files", files);
            component.set("v.uploadDisabled", false);


            var cmpEvent = component.getEvent("deleteUploadedFile");
            cmpEvent.setParam("file", file);
            cmpEvent.fire();

        }catch(excp){
            console.log('excp====', excp);
        }
    }
});