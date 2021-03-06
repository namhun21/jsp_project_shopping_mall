<%@page import="product.dto.ProductCommentDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="product.dto.ProductDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>

<%@ include file="nav.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%ProductDTO product = (ProductDTO) request.getAttribute("product"); %>
<% ArrayList<ProductCommentDTO> clist = (ArrayList<ProductCommentDTO>) request.getAttribute("comment"); %>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript">
	var commentClicked = false;
	
	function getcomment(){
		var comment = document.getElementById("comment");
		if(commentClicked == false){
			comment.style.display="";
			commentClicked = true;
		}else{
			comment.style.display="none";
			commentClicked = false;
		}
	}
	
	function enrollClicked(userid) {
		
		var commentValue = document.getElementById("commentValue");
		
		let today = new Date();
		var year = today.getFullYear(); // 년도
		var month = today.getMonth() + 1;  // 월
		var date = today.getDate();  // 날짜
		var hours = today.getHours(); // 시
		var minutes = today.getMinutes();  // 분
		var seconds = today.getSeconds();  // 초
		var userid = userid;
		console.log(userid);
		console.log(commentValue.value);
		$.ajax({
			url: "CommentUpdate",
			type : "post",
			data : {comment:commentValue.value, pid:<%=product.getPid()%>},
			dataType : "json",
			cache : false,
			success : function(data){
				alert('등록되었습니다.');
				console.log(data[0]);
				$('#commentSpace').prepend("<input type='text' disabled value='"+data.comments+"'>");
				$('#commentSpace').prepend(year+"-"+month+"-"+date+" "+hours+":"+minutes+":"+seconds+"&nbsp;&nbsp;&nbsp; WRITER : "+userid);
				
				commentValue.placeholder ="Write your comment";
				commentValue.value = "";
			},
			error : function(request,status,error){
				//console.log(data.name);
			}
		})
	}
	
	function addToCart(){
		var productCnt = document.getElementById("productCnt").value;
		
		$.ajax({
			url: "AddToCart",
			type : "post",
			data : {productCnt:productCnt, pid:<%=product.getPid()%>},
			dataType : "json",
			cache : false,
			success : function(data){
				alert('장바구니에 담았습니다.');
			},
			error : function(request,status,error){
				//console.log(data.name);
			}
		})
	}
	
	
</script>
</head>
<body>
    <!-- Page Add Section Begin -->
    <section class="page-add">
        <div class="container">
            <div class="row">
                <div class="col-lg-4">
                    <div class="page-breadcrumb">
                        <h2>${product.categorycode }<span>.</span></h2>
                        <a href="#">Home</a>
                        <a href="#">Dresses</a>
                        <a class="active" href="#">Night Dresses</a>
                    </div>
                </div>
                <div class="col-lg-8">
                    <img src="img/add.jpg" alt="">
                </div>
            </div>
        </div>
    </section>
    <!-- Page Add Section End -->

    <!-- Product Page Section Beign -->
    <section class="product-page">
        <div class="container">
            <div class="product-control">
                <a href="#">Previous</a>
                <a href="#">Next</a>
            </div>
            <div class="row">
                <div class="col-lg-6">
                    <div class="product-slider owl-carousel">
                        <div class="product-img">
                            <figure>
                                <img src="${product.product_img }" alt="">
                            </figure>
                        </div>
                        <div class="product-img">
                            <figure>
                                <img src="${product.product_img }" alt="">
                            </figure>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="product-content">
                        <h2>${product.pname }</h2>
                        <div class="pc-meta">
                            <h5>${product.price}원</h5>
                            <div class="rating">
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                            </div>
                        </div>
                        <p>${product.pcontent }</p>
                        <ul class="tags">
                            <li><span>Category :</span> ${product.categorycode}</li>
                            <li><span>Tags :</span> man, shirt, dotted, elegant, cool</li>
                        </ul>
                        <div class="product-quantity">
                            <div class="pro-qty">
                                <input id="productCnt" type="text" value="1">
                            </div>
                        </div>
                        <!-- <a href="#" class="primary-btn pc-btn">Add to cart</a> -->
                        <button type="button" class="btn btn-light" onclick="addToCart()">Add to cart</button>
                        <ul class="p-info">
                            <li>Product Information</li>
                            <li onclick="getcomment()">Reviews</li>
                            <li>Product Care</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Product Page Section End -->
    
    <!-- comment begin -->
	<br>
	<div id="comment" style="display: none;">
		<div class="contact-section">
			<div class="container">
				<div class="row">
					<div class="col-lg-8">
		                <form action="#" class="contact-form">
		                    <div class="row">
		                        <div class="col-lg-12">
		                            <input type="text" placeholder="Write your comment" id="commentValue">
		                        </div>
		                        <div class="col-lg-12 text-right">
		                            <button type="button" onclick="enrollClicked('${userid}')">Enroll comment</button>
		                        </div><br><br><br>
		                        <div id="commentSpace">
			                       <c:set var='checkProduct' value='false'></c:set>
		                        	<c:forEach items="${comment}" var="list">
		                        		<c:choose>
		                        			<c:when test="${product.pid eq list.pid}">
		                        				<c:set var='checkProduct' value='true'></c:set>
		                        			</c:when>
		                        			<c:otherwise>
		                        				<c:set var='checkProduct' value='false'></c:set>
		                        			</c:otherwise>
		                        		</c:choose>
		                        		<c:if test="${checkProduct and (list.isdelete eq 0)}">
											<!-- <div class="col-lg-6"> -->
												${list.repregist } &nbsp;&nbsp;&nbsp; WRITER : ${list.userid } 
					                            <input type="text" value="${list.comments } " disabled>
					                            
					                        <!-- </div><br> -->
										</c:if>
									</c:forEach>
									
		                        </div>
		                    </div>
		                </form>
		            </div>
		       	</div>
	     	</div>
	    </div>
	</div>
	<!-- comment end -->

    <!-- Related Product Section Begin -->
    <section class="related-product spad">
        <div class="container">
            <div class="row">
                <div class="col-lg-12 text-center">
                    <div class="section-title">
                        <h2>Related Products</h2>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-3 col-sm-6">
                    <div class="single-product-item">
                        <figure>
                            <a href="#"><img src="img/products/img-1.jpg" alt=""></a>
                            <div class="p-status">new</div>
                        </figure>
                        <div class="product-text">
                            <h6>Green Dress with details</h6>
                            <p>$22.90</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6">
                    <div class="single-product-item">
                        <figure>
                            <a href="#"><img src="img/products/img-2.jpg" alt=""></a>
                            <div class="p-status sale">sale</div>
                        </figure>
                        <div class="product-text">
                            <h6>Yellow Maxi Dress</h6>
                            <p>$25.90</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6">
                    <div class="single-product-item">
                        <figure>
                            <a href="#"><img src="img/products/img-3.jpg" alt=""></a>
                            <div class="p-status">new</div>
                        </figure>
                        <div class="product-text">
                            <h6>One piece bodysuit</h6>
                            <p>$19.90</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6">
                    <div class="single-product-item">
                        <figure>
                            <a href="#"><img src="img/products/img-4.jpg" alt=""></a>
                            <div class="p-status popular">popular</div>
                        </figure>
                        <div class="product-text">
                            <h6>Blue Dress with details</h6>
                            <p>$35.50</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Related Product Section End -->

    <!-- Footer Section Begin -->
    <footer class="footer-section spad">
        <div class="container">
            <div class="newslatter-form">
                <div class="row">
                    <div class="col-lg-12">
                        <form action="#">
                            <input type="text" placeholder="Your email address">
                            <button type="submit">Subscribe to our newsletter</button>
                        </form>
                    </div>
                </div>
            </div>
            <div class="footer-widget">
                <div class="row">
                    <div class="col-lg-3 col-sm-6">
                        <div class="single-footer-widget">
                            <h4>About us</h4>
                            <ul>
                                <li>About Us</li>
                                <li>Community</li>
                                <li>Jobs</li>
                                <li>Shipping</li>
                                <li>Contact Us</li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-3 col-sm-6">
                        <div class="single-footer-widget">
                            <h4>Customer Care</h4>
                            <ul>
                                <li>Search</li>
                                <li>Privacy Policy</li>
                                <li>2019 Lookbook</li>
                                <li>Shipping & Delivery</li>
                                <li>Gallery</li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-3 col-sm-6">
                        <div class="single-footer-widget">
                            <h4>Our Services</h4>
                            <ul>
                                <li>Free Shipping</li>
                                <li>Free Returnes</li>
                                <li>Our Franchising</li>
                                <li>Terms and conditions</li>
                                <li>Privacy Policy</li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-3 col-sm-6">
                        <div class="single-footer-widget">
                            <h4>Information</h4>
                            <ul>
                                <li>Payment methods</li>
                                <li>Times and shipping costs</li>
                                <li>Product Returns</li>
                                <li>Shipping methods</li>
                                <li>Conformity of the products</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="social-links-warp">
			<div class="container">
				<div class="social-links">
					<a href="" class="instagram"><i class="fa fa-instagram"></i><span>instagram</span></a>
					<a href="" class="pinterest"><i class="fa fa-pinterest"></i><span>pinterest</span></a>
					<a href="" class="facebook"><i class="fa fa-facebook"></i><span>facebook</span></a>
					<a href="" class="twitter"><i class="fa fa-twitter"></i><span>twitter</span></a>
					<a href="" class="youtube"><i class="fa fa-youtube"></i><span>youtube</span></a>
					<a href="" class="tumblr"><i class="fa fa-tumblr-square"></i><span>tumblr</span></a>
				</div>
			</div>

<div class="container text-center pt-5">
                <p><!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
  Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="icon-heart color-danger" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>
  <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. --></p>
            </div>

		</div>
    </footer>
    <!-- Footer Section End -->

    <!-- Js Plugins -->
    <script src="js/jquery-3.3.1.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/jquery.magnific-popup.min.js"></script>
    <script src="js/jquery.slicknav.js"></script>
    <script src="js/owl.carousel.min.js"></script>
    <script src="js/jquery.nice-select.min.js"></script>
    <script src="js/mixitup.min.js"></script>
    <script src="js/main.js"></script>
</body>

</html>