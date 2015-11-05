<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)

    This file is part of Movalys MDK.
    Movalys MDK is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Movalys MDK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License
    along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  extension-element-prefixes="xsi">

<!-- *************************************************
*****  
***** ENTRY POINTS:
*****  
*****  	/storyboard/scenes/*scene/controller[@controllerType='LISTVIEW']/sections/*section/subViews/*subView 
*****  	or
*****  	/xib-container/components/*component
*****  
****************************************************** -->

<xsl:output method="xml"/>

<xsl:include href="ui/storyboard/views/view-mfbutton.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfurltextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfphonetextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfdatepicker.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfdoubletextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfintegertextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mflabel.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfphotothumbnail.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfposition.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfemailtextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfsimplepickerlist.xsl"/>
<xsl:include href="ui/storyboard/views/view-mftextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfslider.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfswitch.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfscanner.xsl"/>
<xsl:include href="ui/storyboard/views/view-mffixedlist.xsl"/>
<xsl:include href="ui/storyboard/views/custom-views.xsl"/>


<xsl:template match="subView[customClass][@id]|component[customClass][@id]" mode="subview-generation">
	<xsl:param name="controllerId"/>
			
	<xsl:comment> [subviews.xsl] subView|component[customClass='<xsl:value-of select="customClass"/>']"  </xsl:comment>

	<xsl:if test="@visibleLabel='true'">
		<view hidden="NO" opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="center" 
			translatesAutoresizingMaskIntoConstraints="NO" contentVerticalAlignment="center" misplaced="YES" >
			<xsl:attribute name="id"><xsl:value-of select="@labelView"/></xsl:attribute>
			<xsl:attribute name ="tag"><xsl:value-of select="position()"/></xsl:attribute>
			<xsl:attribute name ="customClass">MDKLabel</xsl:attribute>
			<xsl:attribute name ="userLabel"><xsl:value-of select="binding"/>-label (MDKLabel)</xsl:attribute>
	 		<constraints>
	        	<constraint firstAttribute="height" >
	            	<xsl:attribute name="id"><xsl:value-of select="@id"/>-label-height</xsl:attribute>
	            	<xsl:attribute name="constant"><xsl:value-of select="@labelViewHeight"/></xsl:attribute>
	     		    <xsl:attribute name="multiplier">1</xsl:attribute>            	
	            </constraint> 
	       </constraints>
		</view>
	</xsl:if>
	

	<view hidden="NO" opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="center" 
		translatesAutoresizingMaskIntoConstraints="NO" contentVerticalAlignment="center" misplaced="YES" >
		<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
		<xsl:attribute name ="tag"><xsl:value-of select="position()"/></xsl:attribute>
		<xsl:attribute name ="customClass"><xsl:value-of select="customClass"/></xsl:attribute>
		<xsl:attribute name ="userLabel"><xsl:value-of select="binding"/> (<xsl:value-of select="customClass"/>)</xsl:attribute>
		<xsl:if test="@userInteractionEnabled='false'"><xsl:attribute name ="userInteractionEnabled">"NO"</xsl:attribute></xsl:if>

 		<constraints>
        	<constraint firstAttribute="height" >
            	<xsl:attribute name="id"><xsl:value-of select="@id"/>-<xsl:value-of select="customClass"/>-height</xsl:attribute>
            	<xsl:attribute name="constant"><xsl:value-of select="@height"/></xsl:attribute>
	       		<xsl:attribute name="multiplier">1</xsl:attribute>            	
            </constraint> 
       </constraints>


		<userDefinedRuntimeAttributes>
			<xsl:apply-templates select="." mode="subview-runtimeAttributes-generation"/>
		</userDefinedRuntimeAttributes>

		<connections>
			<xsl:apply-templates select="." mode="subview-outlets-generation">
				<xsl:with-param name="controllerId"><xsl:value-of select="$controllerId"/></xsl:with-param>
			</xsl:apply-templates>
		</connections>
	
	</view>
	
	
	
</xsl:template>




<xsl:template match="subView[customClass][@id]|component[customClass][@id]" mode="constraints-generation">
	<xsl:param name="cellMargin"/>
	<xsl:param name="containerId"/>
	<xsl:param name="filterNodeName"/>
	<xsl:param name="filterNodeValue"/>
	<xsl:param name="additionalMargin"/>
	
	<xsl:comment> [subviews.xsl] subView[customClass='<xsl:value-of select="customClass"/>']"(cellMargin=<xsl:value-of select="$cellMargin" />,containerId=<xsl:value-of select="$containerId"/>,filterNodeName=<xsl:value-of select="$filterNodeName"/>) mode="constraints" </xsl:comment>
 
 
     <xsl:variable name="additionalMarginValue" >
	    <xsl:choose>
		    <xsl:when test="$additionalMargin=''">0</xsl:when>
			<xsl:otherwise><xsl:value-of select="$additionalMargin" /></xsl:otherwise>
	    </xsl:choose>
    </xsl:variable>
     
    <xsl:variable name="previousNode" >
	    <xsl:choose>
		    <xsl:when test="preceding-sibling::*">
		        <xsl:choose>
			    	<xsl:when test="$filterNodeName!=''"><xsl:value-of select="preceding-sibling::*[*[name()=$filterNodeName and text()=$filterNodeValue]][1]/@id" /></xsl:when>
			   		<xsl:otherwise><xsl:value-of select="preceding-sibling::*[1]/@id" /></xsl:otherwise>
			    </xsl:choose>
			</xsl:when>
	    </xsl:choose>
    </xsl:variable>
    
    
    
    <!-- Generate constraints for the label -->
    <xsl:choose>
		<xsl:when test="@visibleLabel='true'">
		    <xsl:choose>
			    <xsl:when test="$previousNode!=''" >
		      	<!--  following rows -->
		   			<xsl:call-template name="followingItem-constraints-generator">
						<xsl:with-param name="previousItemId"><xsl:value-of select="$previousNode"/></xsl:with-param>
						<xsl:with-param name="itemId"><xsl:value-of select="@labelView"/></xsl:with-param>
						<xsl:with-param name="topMargin"><xsl:value-of select="$cellMargin"/></xsl:with-param>
		   			</xsl:call-template>
			    </xsl:when>
		   		<xsl:otherwise>
		    	<!--  first row -->
		   			<xsl:call-template name="firstItem-constraints-generator">
		   				<xsl:with-param name="topOffset"><xsl:value-of select="../../@framePosY+ ../../@cellMargin + @posY "/></xsl:with-param>
						<xsl:with-param name="containerId"><xsl:value-of select="$containerId"/></xsl:with-param>
						<xsl:with-param name="itemId"><xsl:value-of select="@labelView"/></xsl:with-param>
						<xsl:with-param name="topMargin"><xsl:value-of select="$cellMargin"/></xsl:with-param>
						<xsl:with-param name="leftMargin"><xsl:value-of select="$additionalMarginValue + $cellMargin"/></xsl:with-param>
						<xsl:with-param name="rightMargin"><xsl:value-of select="$cellMargin"/></xsl:with-param>
		   			</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>	    
		</xsl:when>
 	 </xsl:choose>
 	 
     
     <xsl:variable name="fieldPreviousNode" >
	    <xsl:choose>
			<xsl:when test="@visibleLabel='true'"><xsl:value-of select="@labelView"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$previousNode"/></xsl:otherwise>
	    </xsl:choose>
    </xsl:variable>
 
      <xsl:variable name="fieldTopMargin" >
	    <xsl:choose>
			<xsl:when test="@visibleLabel='true'">0</xsl:when>
			<xsl:otherwise><xsl:value-of select="$cellMargin"/></xsl:otherwise>
	    </xsl:choose>
    </xsl:variable>
 	 
    <!-- Generate constraints for the field -->
    <xsl:choose>
	    <xsl:when test="$fieldPreviousNode!=''" >
      	<!--  following rows -->
   			<xsl:call-template name="followingItem-constraints-generator">
				<xsl:with-param name="previousItemId"><xsl:value-of select="$fieldPreviousNode"/></xsl:with-param>
				<xsl:with-param name="itemId"><xsl:value-of select="@id"/></xsl:with-param>
				<xsl:with-param name="topMargin"><xsl:value-of select="$fieldTopMargin"/></xsl:with-param>
   			</xsl:call-template>
	    </xsl:when>
   		<xsl:otherwise>
    	<!--  first row -->
   			<xsl:call-template name="firstItem-constraints-generator">
		   		<xsl:with-param name="topOffset"><xsl:value-of select="./@posY "/></xsl:with-param>
				<xsl:with-param name="containerId"><xsl:value-of select="$containerId"/></xsl:with-param>
				<xsl:with-param name="itemId"><xsl:value-of select="@id"/></xsl:with-param>
				<xsl:with-param name="topMargin"><xsl:value-of select="$fieldTopMargin"/></xsl:with-param>
				<xsl:with-param name="leftMargin"><xsl:value-of select="$additionalMarginValue+$cellMargin"/></xsl:with-param>
				<xsl:with-param name="rightMargin"><xsl:value-of select="$cellMargin"/></xsl:with-param>
   			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>	    
	
	
	
</xsl:template>



<xsl:template name="firstItem-constraints-generator">
	<xsl:param name="containerId"/>
	<xsl:param name="itemId"/>
	<xsl:param name="topOffset"/>
	<xsl:param name="topMargin"/>
	<xsl:param name="leftMargin"/>	
	<xsl:param name="rightMargin"/>	


	<xsl:comment> Positioning constraints of the first subview '<xsl:value-of select="$itemId"/>' => relative to the containing view '<xsl:value-of select="$containerId"/>'</xsl:comment>
   
   	<!-- The top of the current 'object' is just below the top of the containing view -->
    <constraint firstAttribute="top" secondAttribute="top"   >
        <xsl:attribute name="id"><xsl:value-of select="$itemId"/>-top-<xsl:value-of select="$containerId"/>-top</xsl:attribute>
        <xsl:attribute name="firstItem"><xsl:value-of select="$itemId"/></xsl:attribute><!-- => current processed 'object'  -->
        <xsl:attribute name="secondItem"><xsl:value-of select="$containerId"/></xsl:attribute>
        <xsl:attribute name="constant"><xsl:value-of select="$topOffset" /></xsl:attribute>
	    <xsl:attribute name="multiplier">1</xsl:attribute>
    </constraint>      

    <!-- the left side of the current 'object' is at the same aligned with the left side of the containing view -->
    <constraint firstAttribute="leading" secondAttribute="leading"    >
        <xsl:attribute name="id"><xsl:value-of select="$itemId"/>-leading-<xsl:value-of select="$containerId"/>-leading</xsl:attribute>
        <xsl:attribute name="firstItem"><xsl:value-of select="$itemId"/></xsl:attribute><!-- => current processed 'object'  -->
        <xsl:attribute name="secondItem"><xsl:value-of select="$containerId"/></xsl:attribute>
        <xsl:attribute name="constant"><xsl:value-of select="$leftMargin" /></xsl:attribute>
	    <xsl:attribute name="multiplier">1</xsl:attribute>
    </constraint>      

    <!-- the right side of the current 'object' is at the same aligned with the right side of the containing view -->
    <constraint firstAttribute="trailing" secondAttribute="trailing"    >
        <xsl:attribute name="id"><xsl:value-of select="$itemId"/>-trailing-<xsl:value-of select="$containerId"/>-trailing</xsl:attribute>
        <xsl:attribute name="firstItem"><xsl:value-of select="$containerId"/></xsl:attribute>
        <xsl:attribute name="secondItem"><xsl:value-of select="$itemId"/></xsl:attribute><!-- => current processed 'object'  -->
        <xsl:attribute name="constant"><xsl:value-of select="$rightMargin" /></xsl:attribute>
	    <xsl:attribute name="multiplier">1</xsl:attribute>
    </constraint>     
		    
		    
</xsl:template>

<xsl:template name="followingItem-constraints-generator">
	<xsl:param name="previousItemId"/>
	<xsl:param name="itemId"/>
	<xsl:param name="topMargin"/>


	<xsl:comment> Positioning constraints of the subview '<xsl:value-of select="$itemId"/>' => relative to the previous subview '<xsl:value-of select="$previousItemId"/>'</xsl:comment>

    <!-- the top of the current 'object' is just below the bottom of the previous 'object' -->
    <constraint firstAttribute="top" secondAttribute="bottom"  >
        <xsl:attribute name="id"><xsl:value-of select="$itemId"/>-top-<xsl:value-of select="$previousItemId"/>-bottom</xsl:attribute>
        <xsl:attribute name="firstItem"><xsl:value-of select="$itemId"/></xsl:attribute><!-- => current processed 'object'  -->
        <xsl:attribute name="secondItem"><xsl:value-of select="$previousItemId"/></xsl:attribute>
        <xsl:attribute name="constant"><xsl:value-of select="$topMargin" /></xsl:attribute>
        <xsl:attribute name="multiplier">1</xsl:attribute>
    </constraint>      

    <!-- the left side of the current 'object' is at the same aligned with the left side of the previous 'object' -->
    <constraint firstAttribute="leading" secondAttribute="leading" >
        <xsl:attribute name="id"><xsl:value-of select="$itemId"/>-leading-<xsl:value-of select="$previousItemId"/>-leading</xsl:attribute>
        <xsl:attribute name="firstItem"><xsl:value-of select="$itemId"/></xsl:attribute><!-- => current processed 'object'  -->
        <xsl:attribute name="secondItem"><xsl:value-of select="$previousItemId"/></xsl:attribute>
        <xsl:attribute name="constant">0</xsl:attribute>
        <xsl:attribute name="multiplier">1</xsl:attribute>
    </constraint>      

    <!-- the right side of the current 'object' is at the same aligned with the right side of the previous 'object' -->
    <constraint firstAttribute="trailing" secondAttribute="trailing" >
        <xsl:attribute name="id"><xsl:value-of select="$itemId"/>-trailing-<xsl:value-of select="$previousItemId"/>-trailing</xsl:attribute>
        <xsl:attribute name="firstItem"><xsl:value-of select="$itemId"/></xsl:attribute><!-- => current processed 'object'  -->
        <xsl:attribute name="secondItem"><xsl:value-of select="$previousItemId"/></xsl:attribute>
        <xsl:attribute name="constant">0</xsl:attribute>
        <xsl:attribute name="multiplier">1</xsl:attribute>
    </constraint>   
    
</xsl:template>








<xsl:template match="subView[customClass][@id]|component[customClass][@id]" mode="outlets-generation">
	<xsl:param name="collection"/>
	<xsl:comment> [subviews.xsl] subView[customClass='<xsl:value-of select="customClass"/>'] mode=outlets-generation ( @id=<xsl:value-of select="@id" />) </xsl:comment>
	 
 	<xsl:variable name="outletProperty">
	    <xsl:choose>
	        <xsl:when test="propertyName"><xsl:value-of select="propertyName" /></xsl:when>
			<xsl:when test="customClass='MFButton'">button</xsl:when>		
			<xsl:otherwise>
			 	<xsl:comment>*********************
			 	ERREUR DANS subviews.xsl > match="subView|component[customClass][@id]" mode="outlets-generation"
			 	*************************</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
 
    <xsl:choose>
        <xsl:when test="$collection='true'">
			<outletCollection >
				<xsl:attribute name="property"><xsl:value-of select="$outletProperty" />s</xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="@id" />-outlet</xsl:attribute>
				<xsl:attribute name="destination"><xsl:value-of select="@id"/></xsl:attribute>
			</outletCollection>
		</xsl:when>
		<xsl:otherwise>
			<outlet>
				<xsl:attribute name="property"><xsl:value-of select="$outletProperty"/></xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="@id"/>-outlet</xsl:attribute>
				<xsl:attribute name="destination"><xsl:value-of select="@id"/></xsl:attribute>
			</outlet>
		</xsl:otherwise>		
	</xsl:choose>
	
    <xsl:choose>
		<xsl:when test="@visibleLabel='true'">
			<outlet>
				<xsl:attribute name="property"><xsl:value-of select="$outletProperty"/>Label</xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="@id"/>-label-outlet</xsl:attribute>
				<xsl:attribute name="destination"><xsl:value-of select="@labelView"/></xsl:attribute>
			</outlet>
		</xsl:when>
	</xsl:choose>
	
</xsl:template>








<xsl:template match="*" mode="constraints-generation" priority="-900">
<xsl:comment>********** WARNING ************
	[subviews.xsl]  The node  '<xsl:value-of select="name()"/>' (customClass='<xsl:value-of select="customClass"/>', id='<xsl:value-of select="@id"/>', mode='constraints-generation') is not well handled by the generator
*******************************</xsl:comment>
</xsl:template>

<xsl:template match="*" mode="outlets-generation" priority="-900">
	<xsl:param name="collection"/>
<xsl:comment>********** WARNING ************
	[subviews.xsl]  The node  '<xsl:value-of select="name()"/>' (customClass='<xsl:value-of select="customClass"/>', id='<xsl:value-of select="@id"/>', mode='outlets-generation') is not well handled by the generator
*******************************</xsl:comment>
</xsl:template>

<xsl:template match="*" mode="subview-generation" priority="-900">
<xsl:comment>********** WARNING ************
	[subviews.xsl]  The node  '<xsl:value-of select="name()"/>' (customClass='<xsl:value-of select="customClass"/>',id='<xsl:value-of select="@id"/>', mode='subview-generation') is not well handled by the generator
*******************************</xsl:comment>
</xsl:template>

<xsl:template match="*" mode="subview-runtimeAttributes-generation" priority="-900">
<xsl:comment>********** WARNING ************
	[subviews.xsl]  The node  '<xsl:value-of select="name()"/>' (customClass='<xsl:value-of select="customClass"/>',id='<xsl:value-of select="@id"/>', mode='subview-runtimeAttributes-generation') is not well handled by the generator
*******************************</xsl:comment>
</xsl:template>

<xsl:template match="*" mode="subview-outlets-generation" priority="-900">
<xsl:comment>********** WARNING ************
	[subviews.xsl]  The node  '<xsl:value-of select="name()"/>' (customClass='<xsl:value-of select="customClass"/>',id='<xsl:value-of select="@id"/>', mode='subview-outlets-generation') is not well handled by the generator
*******************************</xsl:comment>
</xsl:template>



<xsl:template match="*" priority="-1000">
<xsl:comment>********** WARNING ************
	[subviews.xsl]  The node  '<xsl:value-of select="name()"/>' (customClass='<xsl:value-of select="customClass"/>',id='<xsl:value-of select="@id"/>') is not well handled by the generator
*******************************</xsl:comment>
</xsl:template>


</xsl:stylesheet>
