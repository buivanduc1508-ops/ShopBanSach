<%@ page contentType="image/svg+xml" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String bg = request.getParameter("bg");
	if (bg == null) bg = "b08968";
	String fg = request.getParameter("fg");
	if (fg == null) fg = "ffffff";
	String text = request.getParameter("text");
	if (text == null) text = "BookChill";
	int w = 400;
	int h = 520;
	try { w = Integer.parseInt(request.getParameter("w")); } catch (Exception e) {}
	try { h = Integer.parseInt(request.getParameter("h")); } catch (Exception e) {}
%><?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="<%=w%>" height="<%=h%>" viewBox="0 0 <%=w%> <%=h%>">
	<defs>
		<linearGradient id="g" x1="0%" y1="0%" x2="100%" y2="100%">
			<stop offset="0%" style="stop-color:#<%=bg%>;stop-opacity:1"/>
			<stop offset="100%" style="stop-color:#1a1a1a;stop-opacity:1"/>
		</linearGradient>
	</defs>
	<rect width="100%" height="100%" fill="url(#g)"/>
	<g transform="translate(<%=w/2%>,<%=h/2%>)">
		<text text-anchor="middle" font-family="Georgia, serif" font-size="<%=Math.min(w,h)/6%>" font-weight="bold" fill="#<%=fg%>">📚</text>
		<text y="<%=Math.min(w,h)/4%>" text-anchor="middle" font-family="Georgia, serif" font-size="<%=Math.min(w,h)/14%>" font-weight="bold" fill="#<%=fg%>"><%=text.replaceAll("<","").replaceAll(">","")%></text>
	</g>
</svg>