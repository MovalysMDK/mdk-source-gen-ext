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

<xsl:include href="components/common-component-attributes.xsl"/>
<xsl:include href="components/mfbrowseurltextfield.xsl"/>
<xsl:include href="components/mfbutton.xsl"/>
<xsl:include href="components/mfcallphonenumber.xsl"/>
<xsl:include href="components/mfdatepicker.xsl"/>
<xsl:include href="components/mfdoubletextfield.xsl"/>
<xsl:include href="components/mfenumimage.xsl"/>
<xsl:include href="components/mfintegertextfield.xsl"/>
<xsl:include href="components/mflabel.xsl"/>
<xsl:include href="components/mffixedlist.xsl"/>
<xsl:include href="components/mfnumberpicker.xsl"/>
<xsl:include href="components/mfphotothumbnail.xsl"/>
<xsl:include href="components/mfpickerlist.xsl"/>
<xsl:include href="components/mfposition.xsl"/>
<xsl:include href="components/mfradiogroup.xsl"/>
<xsl:include href="components/mfsendmailtextfield.xsl"/>
<xsl:include href="components/mfsignature.xsl"/>
<xsl:include href="components/mfslider.xsl"/>
<xsl:include href="components/mfswitch.xsl"/>
<xsl:include href="components/mftextfield.xsl"/>
<xsl:include href="components/mftextview.xsl"/>
<xsl:include href="components/mfmultilinetext.xsl"/>
<xsl:include href="components/mfwebview.xsl"/>



	<xsl:template match="view[@type='LIST_1']" mode="partial-List-generation">
		<div>
			<xsl:attribute name="mf-scrollable">mf-scrollable</xsl:attribute>
			<ul>
				<xsl:attribute name="class">mflist-1D</xsl:attribute>
				<mf-list>
<!-- 					<xsl:attribute name="mf-limit-display">10</xsl:attribute> -->
<!-- 					<xsl:attribute name="mf-view-model">viewModel</xsl:attribute> -->
					<xsl:attribute name="mf-field">viewModel.list</xsl:attribute>
					<xsl:attribute name="mf-items-display-step">3</xsl:attribute>
					<xsl:attribute name="mf-row-height">45</xsl:attribute>
					<xsl:attribute name="ng-class">isSelectedItem?'selected':''</xsl:attribute>
					<li>
						<xsl:attribute name="ng-click">navigateDetail(item.<xsl:value-of select="@list-id"/>)</xsl:attribute>

						<h4>
							<xsl:attribute name="class">mflist-item-header</xsl:attribute>
							<span>
								<xsl:attribute name="class">mflist-item-chevron</xsl:attribute>
							</span>
													
							<form> 
								<xsl:attribute name="class">form-horizontal</xsl:attribute>
								<xsl:attribute name="mf-list-item-form">[item.<xsl:value-of select="@list-id"/>]</xsl:attribute>
								<xsl:attribute name="mf-form-name-prefix"><xsl:value-of select="name"/>Form</xsl:attribute>
								<xsl:attribute name="novalidate">true</xsl:attribute>
								<xsl:apply-templates select="attributes/HTML-attribute/child-attributes/HTML-attribute" mode="partial-component-generation">
									<!-- Editable List is not a feature of MDK HTML5, force read only to true -->
									<xsl:with-param name="readonly-override-value" select="'true'"/>
									<xsl:with-param name="viewModel" select="'item'"/>
									<xsl:with-param name="overide-text"><xsl:value-of select="field-name"/></xsl:with-param>
								</xsl:apply-templates>
							</form>
						</h4>
						<p>
							<xsl:attribute name="class">mflist-item-body</xsl:attribute>
						</p>
					</li>
				</mf-list>
			</ul>
		</div>
	</xsl:template>


	<xsl:template match="view[@type='LIST_2']" mode="partial-List-generation">
		<div>
			<xsl:attribute name="mf-scrollable">mf-scrollable</xsl:attribute>
			<accordion>
				<xsl:attribute name="close-others">true</xsl:attribute>
				<xsl:attribute name="class">mflist-2D</xsl:attribute>
				<mf-list>
<!-- 					<xsl:attribute name="mf-limit-display">10</xsl:attribute> -->
<!-- 					<xsl:attribute name="mf-view-model">viewModel</xsl:attribute> -->
					<xsl:attribute name="mf-field">viewModel.list</xsl:attribute>
					<xsl:attribute name="mf-items-display-step">3</xsl:attribute>
					<xsl:attribute name="mf-row-height">45</xsl:attribute>
					<accordion-group>
						<xsl:attribute name="is-open">isopen</xsl:attribute>
						<accordion-heading>
						
							<form> 
								<xsl:attribute name="class">form-horizontal</xsl:attribute>
								<xsl:attribute name="mf-list-item-form">[item.<xsl:value-of select="@list-id"/>]</xsl:attribute>
								<xsl:attribute name="mf-form-name-prefix"><xsl:value-of select="name"/>Form</xsl:attribute>
								<xsl:attribute name="novalidate">true</xsl:attribute>
			
								<xsl:apply-templates select="attributes/HTML-attribute/child-attributes/HTML-attribute" mode="partial-component-generation">
									<!-- Editable List is not a feature of MDK HTML5, force read only to true -->
									<xsl:with-param name="readonly-override-value" select="'true'"/>
									<xsl:with-param name="viewModel" select="'item'"/>
									<xsl:with-param name="overide-text"><xsl:value-of select="field-name"/></xsl:with-param>
	<!-- 								<xsl:with-param name="overide-text"><xsl:text>item.</xsl:text><xsl:value-of select="field-name"/></xsl:with-param> -->
								</xsl:apply-templates>
							</form>
							
							<xsl:if test="@can-add='true'">
								<xsl:text>&#10;</xsl:text>
								<span>
									<xsl:attribute name="class">mflist-item-plus</xsl:attribute>
									<xsl:attribute name="ng-click">addSubItem([{level:0, id:item.<xsl:value-of select="@list-id"/>},{level:1,id:'new'}], $event)</xsl:attribute>
								</span>
							</xsl:if>
						</accordion-heading>
						<ul>
							<xsl:attribute name="class">mflist-sublist</xsl:attribute>
							<li>
								<xsl:attribute name="ng-repeat">subitem in item.list</xsl:attribute>
								<xsl:attribute name="ng-click">navigateDetail([{level:0, id:item.<xsl:value-of select="@list-id"/>},{level:1,id:subitem.<xsl:value-of select="@list-id"/>}])</xsl:attribute>
								<xsl:attribute name="ng-class">isSelectedItem?'selected':''</xsl:attribute>
		
								<form> 
									<xsl:attribute name="class">form-horizontal mflist-item-body</xsl:attribute>
									<xsl:attribute name="mf-list-item-form">[item.<xsl:value-of select="@list-id"/>, subitem.<xsl:value-of select="@list-id"/>]</xsl:attribute>
									<xsl:attribute name="mf-form-name-prefix"><xsl:value-of select="name"/>Form</xsl:attribute>
									<xsl:attribute name="novalidate">true</xsl:attribute>
									
									
									<xsl:apply-templates select="attributes/HTML-attribute/level2-attributes/HTML-attribute" mode="partial-component-generation">
									<!-- Editable List is not a feature of MDK HTML5, force read only to true -->
										<xsl:with-param name="readonly-override-value" select="'true'"/>
										<xsl:with-param name="viewModel" select="'subitem'"/>
										<xsl:with-param name="overide-text"><xsl:value-of select="field-name"/></xsl:with-param>
									</xsl:apply-templates>
									
									<span>
									<xsl:attribute name="class">mflist-item-chevron</xsl:attribute>
									</span>
								</form>
							</li>
						</ul>
					</accordion-group>
				</mf-list>
			</accordion>
		</div>
	</xsl:template>
	
	<xsl:template match="HTML-attribute" mode="partial-component-generation" priority="-900">
		<xsl:comment>********** WARNING ************
			[partials.xsl]  The attribute  '<xsl:value-of select="field-name"/>' (type ='<xsl:value-of select="visualfield/component"/>', mode='partial-component-generation') is not well handled by the generator
		*******************************</xsl:comment>
	</xsl:template>
	

</xsl:stylesheet>