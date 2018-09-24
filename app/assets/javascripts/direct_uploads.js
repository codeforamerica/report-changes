var directUpload = (function () {
    return {
        init: function () {
            $('input[type=file]').each(function (index, fileInput) {
                const url = fileInput.dataset.directUploadUrl;

                var uploadBtn = document.getElementById('file-upload');
                uploadBtn.addEventListener('click', function (e) {
                    fileInput.click();
                });

                fileInput.addEventListener('change', function (e) {
                    for(var i=0,file;file=this.files[i];i++) {
                        $('.verification-upload-icon').hide();
                        const upload = new ActiveStorage.DirectUpload(file, url);
                        upload.create(function (error, blob) {
                            const hiddenField = document.createElement('input');
                            hiddenField.setAttribute("type", "hidden");
                            hiddenField.setAttribute("value", blob.signed_id);
                            hiddenField.name = fileInput.name;
                            document.querySelector('form').appendChild(hiddenField);

                            $('.uploaded-files').append(
                                '<div class="doc-preview">' +
                                '<div class="doc-preview__info">' +
                            '<h4>' + blob.filename + '</h4>' +
                            '</div>' +
                            '<div class="doc-preview__thumb">' +
                            '<img src="' + '/rails/active_storage/blobs/' + blob.signed_id + '/' + blob.filename + '">' +
                            '</div>' +
                            '</div>'
                            );
                        });
                    };
                    fileInput.value = null;
                });
            });
        }
    }
})();


$(document).ready(function () {
    directUpload.init();
});
