function FeaturesFromPortrait(portrait, num) 
%portrait：图片路径
%num：要提取的最显著的num个特征点
  LoadVlfeat; 
  figure; 
  I = vl_impattern(portrait) ;
  image(I) ;

  I = single(rgb2gray(I)) ;
  [f,d] = vl_sift(I) ;
  
  dsum = sum(d);
  [drop, perm] = sort(dsum, 'descend'); 

  sel = perm(1:num) ;
  h1 = vl_plotframe(f(:,sel)) ;
  h2 = vl_plotframe(f(:,sel)) ;
  set(h1,'color','k','linewidth',3) ;
  set(h2,'color','y','linewidth',2) ;

  h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
  set(h3,'color','g') ;
end 
