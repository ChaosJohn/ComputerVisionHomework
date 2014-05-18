function sift_match(img1, img2, num) 
%img1：图片1路径
%img2：图片2路径
%num：最匹配的num个特征点
  LoadVlfeat; 

  pfx = fullfile(vl_root,'figures','demo') ;
  randn('state',0) ;
  rand('state',0) ;

  % --------------------------------------------------------------------
  %                                                    Create image pair
  % --------------------------------------------------------------------

  Ia = imread(img1) ;
  Ib = imread(img2) ;

  % --------------------------------------------------------------------
  %                                           Extract features and match
  % --------------------------------------------------------------------

  [fa,da] = vl_sift(im2single(rgb2gray(Ia))) ;
  [fb,db] = vl_sift(im2single(rgb2gray(Ib))) ;

  [matches, scores] = vl_ubcmatch(da,db) ;

  [drop, perm] = sort(scores, 'descend') ;
  matches = matches(:, perm(1:num)) ;
  scores  = scores(perm(1:num)) ;

  figure(1) ; clf ;
  imagesc(cat(2, Ia, Ib)) ;

  xa = fa(1,matches(1,:)) ;
  xb = fb(1,matches(2,:)) + size(Ia,2) ;
  ya = fa(2,matches(1,:)) ;
  yb = fb(2,matches(2,:)) ;

  hold on ;
  h = line([xa ; xb], [ya ; yb]) ;
  set(h,'linewidth', 1, 'color', 'b') ;

  vl_plotframe(fa(:,matches(1,:))) ;
  fb(1,:) = fb(1,:) + size(Ia,2) ;
  vl_plotframe(fb(:,matches(2,:))) ;
  axis image off ;

