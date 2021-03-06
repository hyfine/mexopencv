classdef TestStructuredEdgeDetection
    %TestStructuredEdgeDetection

    properties (Constant)
        im = fullfile(mexopencv.root(),'test','balloon.jpg');
    end

    methods (Static)
        function test_1
            img = imread(TestStructuredEdgeDetection.im);
            img = single(img) / 255.0;

            modelFilename = get_model_file();
            pDollar = cv.StructuredEdgeDetection(modelFilename);

            E = pDollar.detectEdges(img);
            validateattributes(E, {'single'}, ...
                {'size',[size(img,1) size(img,2)], '>=',0, '<=',1});

            O = pDollar.computeOrientation(E);
            validateattributes(O, {'single'}, ...
                {'size',[size(img,1) size(img,2)]});

            E_nms = pDollar.edgesNms(E, O);
            validateattributes(E_nms, {'single'}, ...
                {'size',[size(img,1) size(img,2)], '>=',0, '<=',1});
        end

        function test_custom_feat_extract
            %TODO: custom feature extractor
            if true
                error('mexopencv:testskip', 'todo');
            end

            img = imread(TestStructuredEdgeDetection.im);
            img = single(img) / 255.0;

            modelFilename = get_model_file();
            pDollar = cv.StructuredEdgeDetection(modelFilename, ...
                'myRFFeatureGetter');
            E = pDollar.detectEdges(img);
        end
    end

end

function features = myRFFeatureGetter(src, opts)
    nsize = [size(src,1) size(src,2)] ./ opts.shrinkNumber;
    features = zeros([nsize opts.numberOfOutputChannels], 'single');
    %TODO: ... compute features
end

function fname = get_model_file()
    fname = fullfile(mexopencv.root(),'test','model.yml.gz');
    if exist(fname, 'file') ~= 2
        % download model from GitHub
        url = 'https://cdn.rawgit.com/opencv/opencv_extra/3.2.0/testdata/cv/ximgproc/model.yml.gz';
        urlwrite(url, fname);
    end
end
