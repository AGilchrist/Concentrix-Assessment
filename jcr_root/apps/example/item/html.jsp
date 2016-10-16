<!--
/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
-->
<!-- simple JSP rendering test -->
<%@page session="true" import="org.apache.sling.api.resource.*, javax.jcr.*"%>
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0"%>
<%@page language="java" import="java.util.Map" %>
<%@page language="java" import="java.util.HashMap" %>
<%@page language="java" import="java.util.List" %>
<%@page language="java" import="java.util.ArrayList" %>
<sling:defineObjects/>
<%
    Resource myResource = resourceResolver.getResource("example/item/players");
	List<String> playerNames = new ArrayList<String>();
	if (myResource != null){
		if(resourceResolver.hasChildren(myResource)){
			for (Resource r : resourceResolver.getChildren(myResource)){
				playerNames.add(r.getName());
			}
		}
	}
%>

<script type="text/javascript">

function showCreatePlayerDialogue()
{
	var list = document.getElementById("createPlayerDialogue");
	if (list.style.display !== 'none') {
		list.style.display = 'none';
    }
    else {
    	list.style.display = 'block';
    }
}

function showeditPlayerDialogue()
{
	var list = document.getElementById("editPlayerDialogue");
	if (list.style.display !== 'none') {
		list.style.display = 'none';
    }
    else {
    	list.style.display = 'block';
    }
}

function showDeletePlayerDialogue()
{
	var list = document.getElementById("deletePlayerDialogue");
	if (list.style.display !== 'none') {
		list.style.display = 'none';
    }
    else {
    	list.style.display = 'block';
    }
}

function showPlayers()
{
	var list = document.getElementById("listOfPlayers");
	var button = document.getElementById("show/hide");
	if (list.style.display !== 'none') {
		list.style.display = 'none';
		button.innerHTML = "Show all players";
    }
    else {
    	list.style.display = 'block';
    	button.innerHTML = "Hide all players";
    }
}
</script>

<h1><%= resource.adaptTo(ValueMap.class).get("jcr:title") %></h1>
<p><%= resource.adaptTo(ValueMap.class).get("jcr:description") %></p>
<br>
<br>
<button onclick="showCreatePlayerDialogue()">Create a new player</button>
<br><br>
<button id="show/hide" onclick="showPlayers()">Show all players</button>
<br><br>
<button onclick="showDeletePlayerDialogue()">Delete a player</button>
<br><br>
<button onclick="showeditPlayerDialogue()">Edit a player</button>
<br><br>

<form action="example.html" id="createPlayerDialogue" style="display:none">
Name: <input type="text" id="createName" name="createName">
<br><br>
<input type="submit" value="Create">
</form>

<form id="editPlayerDialogue" style="display:none">
Player: <select name="oldName">
<% for (String name : playerNames) { %>
	<option><%= name %></option>
	<% } %>
</select>
<br><br>
New name: <input type="text" id="newName" name="newName">
<br><br>
<input type="submit" value="edit">
</form>

<form id="deletePlayerDialogue" style="display:none">
Player: <select name="deleteName">
<% for (String name : playerNames) { %>
	<option><%= name %></option>
	<% } %>
</select>
<br><br>
<input type="submit" value="delete">
</form>

<%
String createName = request.getParameter("createName");
String deleteName = request.getParameter("deleteName");
String oldName = request.getParameter("oldName");
String newName = request.getParameter("newName");
Resource res = null;
boolean exists = false;
Map<String,Object> properties = new HashMap<String,Object>();
properties.put("jcr:primaryType", "nt:unstructured");
properties.put("sling:resourceType", "example/item");

if (createName != null && createName.length() > 0){
	 if(resourceResolver.hasChildren(myResource)){
		for (Resource r : resourceResolver.getChildren(myResource)){
			if (r.getName().equals(createName)){
				exists = true;
			}
		}
	}
	if (!exists){
		resourceResolver.create(myResource, createName, properties);
		resourceResolver.commit();
	}
}

if (deleteName != null && deleteName.length() > 0){
	 if(resourceResolver.hasChildren(myResource)){
		for (Resource r : resourceResolver.getChildren(myResource)){
			if (r.getName().equals(deleteName)){
				exists = true;
				res = r;
			}
		}
	}
	if (exists){
		resourceResolver.delete(res);
		resourceResolver.commit();
		res = null;
	}
}

if (oldName != null && oldName.length() > 0){
	 if(resourceResolver.hasChildren(myResource)){
		for (Resource r : resourceResolver.getChildren(myResource)){
			if (r.getName().equals(oldName)){
				exists = true;
				res = r;
			}
		}
	}
	if (exists){
		String theName = "";
		if (newName != null && newName.length() > 0){
				theName = newName;
		} else {
			theName = oldName;
		}
		resourceResolver.delete(res);
		resourceResolver.create(myResource, theName, properties);
		resourceResolver.commit();
		res = null;
	}
}

%>

<ul id="listOfPlayers" style="display:none">
	<% for (String name : playerNames){
		%> <li> <%= name %></li> <%
		}
	%>
</ul>