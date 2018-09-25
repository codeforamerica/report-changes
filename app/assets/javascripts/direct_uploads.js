var directUpload = (function () {
    return {
        init: function () {
            var addDeleteFileListener = function() {
                $('.delete-file-link').each(function (index, deleteFileLink) {
                    deleteFileLink.addEventListener('click', function (e) {
                        deleteFileLink.closest('.uploaded-file-detail').remove();
                    });
                });
            };

            $('input[type=file]').each(function (index, fileInput) {
                const url = fileInput.dataset.directUploadUrl;

                var uploadBtn = document.getElementById('file-upload');
                uploadBtn.addEventListener('click', function (e) {
                    e.preventDefault();
                    fileInput.click();
                });

                fileInput.addEventListener('change', function (e) {
                    for(var i=0,file;file=this.files[i];i++) {
                        $('.verification-upload-icon').hide();
                        const upload = new ActiveStorage.DirectUpload(file, url);
                        upload.create(function (error, blob) {
                            var context = {filename: blob.filename, signed_id: blob.signed_id, inputName: fileInput.name};
                            var uploadedFileDetailHtml = HandlebarsTemplates['uploaded_file_detail'](context);
                            $('.uploaded-files').append(uploadedFileDetailHtml);
                            addDeleteFileListener();
                        });
                    };
                    fileInput.value = null;
                });
            });

            addDeleteFileListener();
        }
    }
})();

$(document).ready(function () {
    directUpload.init();
});
