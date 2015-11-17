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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	
	<!-- UPDATE IDENTIFIABLE ............................................................................. -->

	<xsl:template match="mapping" mode="generate-method-update">
		<xsl:text>this.clear();&#13;</xsl:text>
		<xsl:text>if (p_oEntity != null) {&#13;</xsl:text>
		<!-- derived attributes are not in the mapping node -->
		<xsl:apply-templates select="../attribute[@derived='true']" mode="generate-method-update"/>
		<!--  mapping node -->
		<xsl:apply-templates select=".//entity[@mapping-type='vmlist']" mode="generate-method-update-initvmlist"/>

		<xsl:apply-templates select="attribute" mode="generate-method-update"/>

		<xsl:if test=".//entity[@mapping-type='vm' or @mapping-type='vmlist']">
			<xsl:text>ViewModelCreator oVMCreator = (ViewModelCreator) BeanLoader.getInstance().getBean(ExtBeanType.ViewModelCreator);&#13;</xsl:text>
		</xsl:if>

		<xsl:apply-templates select="entity" mode="generate-method-update"/>

		<xsl:text>&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">update-from-identifiable</xsl:with-param>
			<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="attribute[@derived='true']" mode="generate-method-update">
		<xsl:param name="var-name"><xsl:value-of select="@name"/></xsl:param>
		<xsl:text>this.set</xsl:text>
		<xsl:value-of select="translate(substring($var-name,1,1),$smallcase,$uppercase)"/>
		<xsl:value-of select="substring($var-name,2)"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="@init"/>
		<xsl:text>);&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="entity" mode="generate-method-update">
		<xsl:param name="var-parent-entity">p_oEntity</xsl:param>

		<xsl:variable name="var-entity">
			<xsl:text>o</xsl:text>
			<xsl:value-of select="../@type"/>
			<xsl:value-of select="@type"/>
			<xsl:value-of select="position()"/>
		</xsl:variable>

		<xsl:value-of select="@type"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$var-entity"/>
		<xsl:text> = </xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="getter/@name"/>
		<xsl:text>();&#13;</xsl:text>
		<xsl:text>if (</xsl:text><xsl:value-of select="$var-entity"/><xsl:text> == null) {&#13;</xsl:text>
		<xsl:apply-templates select="." mode="generate-call-clear"/>
		<xsl:text>} else {&#13;</xsl:text>

		<xsl:apply-templates select="attribute" mode="generate-method-update">
			<xsl:with-param name="var-entity" select="$var-entity"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="entity" mode="generate-method-update">
			<xsl:with-param name="var-parent-entity" select="$var-entity"/>
		</xsl:apply-templates>

		<xsl:text>}</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="entity[@mapping-type='vm']" mode="generate-method-update">
		<xsl:param name="var-parent-entity">p_oEntity</xsl:param>

		<xsl:text>if (</xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="getter/@name"/>
		<xsl:text>() == null) {&#13;</xsl:text>
		<xsl:text>this.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text> = null;&#13;</xsl:text>
		<xsl:text>}&#13; else {&#13;</xsl:text>
		<xsl:text>this.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text> = oVMCreator.createOrUpdate</xsl:text>
		<xsl:value-of select="@vm-type"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="getter/@name"/>
		<xsl:text>()</xsl:text>
		<xsl:text>);&#13;</xsl:text>

		<xsl:text>}&#13;</xsl:text>
	</xsl:template>

	<!-- Case: combo -->
	<xsl:template match="entity[@mapping-type='vm_comboitemselected']" mode="generate-method-update">
		<xsl:param name="var-parent-entity">p_oEntity</xsl:param>
		<xsl:variable name="vm-attribute"><xsl:value-of select="@vm-attr"/></xsl:variable>
		<xsl:text>if (</xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="getter/@name"/>
		<xsl:text>() == null) {&#13;</xsl:text>
		<xsl:text>this.set</xsl:text>
		<xsl:value-of select="substring($vm-attribute, 2, string-length($vm-attribute)-1)"></xsl:value-of>
		<xsl:text>(null);&#13;</xsl:text>
		<xsl:text>}&#13; else {&#13;</xsl:text>
		
		<xsl:choose>
			<!-- Case: combo in fixed list -->
			<xsl:when test="../../type/name = 'FIXED_LIST'">
				<xsl:text>this.set</xsl:text>
				<xsl:value-of select="substring($vm-attribute, 2, string-length($vm-attribute)-1)"></xsl:value-of>
				<xsl:text>(((</xsl:text>
				<xsl:value-of select="../../parent-viewmodel/master-interface/@name"/>
				<xsl:text>) this.getParent()).getLst</xsl:text>
				<xsl:value-of select="@vm-type"/>
				<xsl:text>().getCacheVMById(</xsl:text>
				<xsl:value-of select="$var-parent-entity"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="getter/@name"/>
				<xsl:text>()</xsl:text>
				<xsl:text>));&#13;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>this.set</xsl:text>
				<xsl:value-of select="substring($vm-attribute, 2, string-length($vm-attribute)-1)"></xsl:value-of>
				<xsl:text>(this.lst</xsl:text>
				<xsl:value-of select="@vm-type"/>
				<xsl:text>.getCacheVMById(</xsl:text>
				<xsl:value-of select="$var-parent-entity"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="getter/@name"/>
				<xsl:text>()</xsl:text>
				<xsl:text>));&#13;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:text>}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="entity[@mapping-type='vmlist']" mode="generate-method-update">
		<xsl:param name="var-parent-entity">p_oEntity</xsl:param>
		<xsl:param name="var-parent-vm">this</xsl:param>

		<xsl:text>if (</xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="getter/@name"/>
		<xsl:text>() !=null) {&#13;</xsl:text>

		<xsl:text>synchronized (this.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text>) {&#13;</xsl:text>

		<xsl:text>for (</xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text> o</xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text> : </xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="getter/@name"/>
		<xsl:text>()) {&#13;</xsl:text>

		<xsl:text>this.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text>.add(oVMCreator.createOrUpdate</xsl:text>
		<xsl:value-of select="@vm-type"/>
		<xsl:text>(o</xsl:text>
		<xsl:value-of select="@type"/>
		<!-- on passe le parent que pour les fixed list -->
		<xsl:if test="../../type/name != 'LISTITEM_2' and ../../type/name != 'LISTITEM_3'">
			<xsltext>, this</xsltext>
		</xsl:if>
		<xsl:text>), true);&#13;</xsl:text>

		<xsl:text>}&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
		
	</xsl:template>
	
	
	<xsl:template match="attribute" mode="generate-method-update">
		<xsl:param name="var-entity">p_oEntity</xsl:param>

		<xsl:variable name="vm-attr" select="@vm-attr" />
		<xsl:variable name="vm-setter" select="/viewmodel/attribute[@name=$vm-attr]/set-accessor | /viewmodel/identifier/attribute[@name=$vm-attr]/set-accessor" />
		<!-- /viewmodel//attribute[@name='id_id' and @visibility='private']/set-accessor -->
		<xsl:text>this.</xsl:text>
		<!-- make setter of VM -->
		<xsl:value-of select="$vm-setter"/>
		<xsl:text>(</xsl:text>
		<xsl:choose>
			<xsl:when test="getter/@formula">
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="getter/@formula"/>
					<xsl:with-param name="replace" select="'VALUE'"/>
					<xsl:with-param name="by">
						<xsl:value-of select="$var-entity"/>
						<xsl:text>.</xsl:text>
						<xsl:value-of select="getter/@name"/>
						<xsl:text>()</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>

			<xsl:otherwise>
				<xsl:value-of select="$var-entity"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="getter/@name"/>
				<xsl:text>()</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>);&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="entity[@mapping-type='vmlist']" mode="generate-method-update-initvmlist">
		<xsl:param name="var-name"><xsl:value-of select="@vm-attr"/></xsl:param>	
		<xsl:param name="var-parent-vm">this</xsl:param>
		<xsl:param name="var-non-impl-name"><xsl:value-of select="substring($var-name,0,string-length($var-name)-3)"/></xsl:param>
		  			
		<xsl:text>this.set</xsl:text>


		<xsl:choose>
		  <xsl:when test="substring($var-name,string-length($var-name)-3) = 'Impl'">
		  		<xsl:value-of select="translate(substring($var-non-impl-name,1,1),$smallcase,$uppercase)"/>
        		<xsl:value-of select="substring($var-non-impl-name,2)"/>	
		  </xsl:when>
		  <xsl:otherwise>
		  		<xsl:value-of select="translate(substring($var-name,1,1),$smallcase,$uppercase)"/>
       			<xsl:value-of select="substring($var-name,2)"/>	
		  </xsl:otherwise>
		</xsl:choose>
	
        <xsl:text>(</xsl:text>
		<xsl:text>new ListViewModelImpl&lt;</xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="@vm-type"/>
		<xsl:text>&gt;(</xsl:text>
		<xsl:value-of select="$var-parent-vm"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="@vm-type"/>
		<xsl:text>.class, false));&#13;</xsl:text>
	</xsl:template>

</xsl:stylesheet>
