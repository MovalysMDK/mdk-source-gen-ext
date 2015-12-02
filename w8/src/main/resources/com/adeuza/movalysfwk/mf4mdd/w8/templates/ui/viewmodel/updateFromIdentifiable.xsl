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


<!-- updateFromIdentifiable method (interface) -->
<xsl:template match="viewmodel" mode="updateFromIdentifiable-method-header">

	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Update the view model with the data in the given object of type </xsl:text><xsl:value-of select="./entity-to-update/name"/><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>/// &lt;param name="entity"&gt; entity to fill the view model. The entity can be null and in this case clears the data in the view model.&lt;/param&gt;&#13;</xsl:text>
	<xsl:text>//void UpdateFromIdentifiable(</xsl:text><xsl:value-of select="./entity-to-update/name"/><xsl:text> entity);&#13;</xsl:text>

</xsl:template>

<!-- updateFromIdentifiable method (implementation)-->
<xsl:template match="viewmodel" mode="updateFromIdentifiable-method">

	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public override void UpdateFromIdentifiable(IMEntity entity){&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">updateFromIdentifiable-before</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	<xsl:if test="./entity-to-update/name">
		<xsl:value-of select="./entity-to-update/name"/><xsl:text> _entity = entity as </xsl:text>
		<xsl:value-of select="./entity-to-update/name"/><xsl:text>;</xsl:text>
		<xsl:apply-templates select="mapping" mode="generate-method-update"/>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>this.IsDirty = false;&#13;</xsl:text>
	</xsl:if>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">updateFromIdentifiable-after</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	<xsl:text>}&#13;</xsl:text>
</xsl:template>	

<!-- UPDATE IDENTIFIABLE ............................................................................. -->
<xsl:template match="mapping" mode="generate-method-update">
	<xsl:text>	this.Clear();</xsl:text>
	<xsl:text>	if ( _entity != null) {</xsl:text>

	<xsl:apply-templates select="attribute" mode="generate-method-update"/>

	<!-- <xsl:if test=".//entity[@mapping-type='vm' or @mapping-type='vmlist']">
		<xsl:text>IViewModelCreator viewModelCreator =  ClassLoader.GetInstance().GetBean&lt;IViewModelCreator&gt;();</xsl:text>
	</xsl:if>-->
	
	<xsl:apply-templates select=".//entity[@mapping-type='vmlist']" mode="generate-method-update-initvmlist"/>
	<xsl:apply-templates select="entity" mode="generate-method-update"/>

	<xsl:apply-templates select="./.." mode="generate-method-update"/>
	
	<xsl:apply-templates select="../dataloader-impl/dao-interface/dao/class/association[@type='many-to-one']" mode="generate-method-update"/>

	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">update-from-identifiable</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	<xsl:text>	}&#13;</xsl:text>
</xsl:template>

<xsl:template match="entity" mode="generate-method-update">
	<xsl:param name="var-parent-entity">_entity</xsl:param>

	<xsl:if test="not(@mapping-type='vm_comboitemselected')">

		<xsl:variable name="var-entity">
			<xsl:text>o</xsl:text>
			<xsl:value-of select="../@type"/>
			<xsl:value-of select="@type"/>
			<xsl:value-of select="position()"/>
		</xsl:variable>
		<xsl:text></xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$var-entity"/>
		<xsl:text> = </xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:variable name="getter-name">
			<xsl:call-template name="string-uppercase-firstchar">
				<xsl:with-param name="text" select="getter/@name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$getter-name"/>
		<xsl:text>;</xsl:text>
		<xsl:text>		if (</xsl:text><xsl:value-of select="$var-entity"/><xsl:text> == null) {	</xsl:text>
		<xsl:apply-templates select="." mode="generate-call-clear"/>
		<xsl:text>}&#13; else {</xsl:text>
	
		<xsl:apply-templates select="attribute" mode="generate-method-update">
			<xsl:with-param name="var-entity" select="$var-entity"/>
		</xsl:apply-templates>
	
		<xsl:apply-templates select="entity" mode="generate-method-update">
			<xsl:with-param name="var-parent-entity" select="$var-entity"/>
		</xsl:apply-templates>
	
		<xsl:text>}&#13;</xsl:text>
	
	</xsl:if>
	
</xsl:template>

<!--  pas maintenant -->
<xsl:template match="entity[@mapping-type='vm']" mode="generate-method-update">
	<xsl:param name="var-parent-entity">_entity</xsl:param>

	<xsl:text>if (</xsl:text>
	<xsl:value-of select="$var-parent-entity"/>
	<xsl:text>.</xsl:text>
	<xsl:value-of select="getter/@name"/>
	<xsl:text> == null) {</xsl:text>
	<xsl:text>this.</xsl:text>
	<xsl:value-of select="@vm-attr"/>
	<xsl:text> = null;</xsl:text>
	<xsl:text>}&#13; else {</xsl:text>
	<xsl:text>this.</xsl:text>
	<xsl:value-of select="@vm-attr"/>
	<xsl:text> = oVMCreator.Get</xsl:text>
	<xsl:value-of select="@vm-type"/>
	<xsl:text>(</xsl:text>
	<xsl:value-of select="$var-parent-entity"/>
	<xsl:text>.</xsl:text>
	<xsl:value-of select="getter/@name"/>
	<xsl:text></xsl:text>
	<xsl:text>);</xsl:text>

	<xsl:text>}&#13;</xsl:text>
</xsl:template>

<!-- POUR MAINTENANT (LIST) -->
<xsl:template match="entity[@mapping-type='vmlist']" mode="generate-method-update">
	<xsl:param name="var-parent-entity">_entity</xsl:param>
	<xsl:param name="var-parent-vm">this</xsl:param>

	<xsl:text>if (</xsl:text>
	<xsl:value-of select="$var-parent-entity"/>
	<xsl:text>.</xsl:text>
	<xsl:variable name="getter-name">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="getter/@name"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:value-of select="$getter-name"/>
	<xsl:text> != null) {</xsl:text>
	
	<xsl:text>foreach (</xsl:text><xsl:value-of select="@type"/><xsl:text> itemData</xsl:text>
	<xsl:value-of select="@type"/>
	<xsl:text> in </xsl:text>
	<xsl:value-of select="$var-parent-entity"/>
	<xsl:text>.</xsl:text>
	<xsl:value-of select="$getter-name"/>
	<xsl:text> ) {</xsl:text>

	<xsl:choose>
		<xsl:when test="(../../type/name = 'LISTITEM_2' or ../../type/name = 'LISTITEM_3') and (../../type/name = 'MASTER' and ../../entity-to-update)">
			<xsl:value-of select="../../subvm/viewmodel/subvm/viewmodel/implements/interface/@name"/><xsl:text> vmCell = viewModelCreator.CreateOrUpdate</xsl:text>
			<xsl:value-of select="../../subvm/viewmodel/subvm/viewmodel/implements/interface/@name"/>
			<xsl:text>(itemData</xsl:text><xsl:value-of select="@type"/><xsl:text>, this</xsl:text>
	 	 </xsl:when>
	 	 <xsl:when test="(../../type/name = 'LISTITEM_2' or ../../type/name = 'LISTITEM_3') and not(../../type/name = 'MASTER' and ../../entity-to-update)">
			<xsl:value-of select="../../subvm/viewmodel/subvm/viewmodel/implements/interface/@name"/><xsl:text> vmCell = viewModelCreator.CreateOrUpdate</xsl:text>
			<xsl:value-of select="../../subvm/viewmodel/subvm/viewmodel/implements/interface/@name"/>
			<xsl:text>(itemData</xsl:text><xsl:value-of select="@type"/>
	 	 </xsl:when>
	 	 <xsl:when test="not(../../type/name = 'LISTITEM_2' or ../../type/name = 'LISTITEM_3') and (../../type/name = 'MASTER' and ../../entity-to-update)">
			<xsl:value-of select="@vm-type"/><xsl:text>ItemCell vmCell = viewModelCreator.CreateOrUpdate</xsl:text>
			<xsl:value-of select="@vm-type"/>
			<xsl:text>ItemCell(itemData</xsl:text><xsl:value-of select="@type"/><xsl:text>, this</xsl:text>
	 	 </xsl:when>
	 	 <xsl:otherwise>
			<xsl:value-of select="@vm-type"/><xsl:text> vmCell = viewModelCreator.CreateOrUpdate</xsl:text>
			<xsl:value-of select="@vm-type"/>
			<xsl:text>ItemCell(itemData</xsl:text><xsl:value-of select="@type"/>
		 </xsl:otherwise>
	</xsl:choose>
	<xsl:text>);</xsl:text>
	
	<xsl:text>temp</xsl:text>
	<xsl:value-of select="@vm-attr"/>
	<xsl:text>.ListViewModel.Add(vmCell);</xsl:text>
	<xsl:text>	}&#13;</xsl:text>
	<xsl:text>	}&#13;</xsl:text>
	
	<xsl:text>this.Lst</xsl:text>
	<xsl:value-of select="@vm-type"/>
	<xsl:text> = temp</xsl:text>
	<xsl:value-of select="@vm-attr"/>
	<xsl:text>;</xsl:text>
 
</xsl:template>

<xsl:template match="attribute" mode="generate-method-update">
	<xsl:param name="var-entity">_entity</xsl:param>

	<xsl:text>this.</xsl:text>
	<xsl:variable name="vm-attr">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="@vm-attr"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:value-of select="$vm-attr"/>
	<xsl:choose>
		<xsl:when test="contains(@vm-attr,'_id')='true'">
			<xsl:text> = </xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>.Value = </xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="getter/@formula">
			<xsl:call-template name="string-replace-all">
				<xsl:with-param name="text" select="getter/@formula"/>
				<xsl:with-param name="replace" select="'VALUE'"/>
				<xsl:with-param name="by">
					<xsl:value-of select="$var-entity"/>
					<xsl:text>.</xsl:text>
					<xsl:variable name="getter-name">
						<xsl:call-template name="string-uppercase-firstchar">
							<xsl:with-param name="text" select="getter/@name"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="$getter-name"/>
				</xsl:with-param>
			</xsl:call-template>

		</xsl:when>

		<xsl:otherwise>
			<xsl:value-of select="$var-entity"/>
			<xsl:text>.</xsl:text>
			<xsl:variable name="getter-name">
				<xsl:call-template name="string-uppercase-firstchar">
					<xsl:with-param name="text" select="getter/@name"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$getter-name"/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="entity[@mapping-type='vmlist']" mode="generate-method-update-initvmlist">
	<xsl:param name="var-parent-vm">this</xsl:param>
	<xsl:value-of select="@vm-typelist"/>
	<xsl:text> temp</xsl:text>
	<xsl:value-of select="@vm-attr"/>
	<xsl:text> = </xsl:text>
	<xsl:text>viewModelCreator.CreateOrUpdate</xsl:text>
	<xsl:value-of select="@vm-typelist" />
	<xsl:text>(null, this);&#13;</xsl:text>
</xsl:template>

<!--  Cas d'une pickerlist dans une fixedList -->
<xsl:template match="viewmodel[type/name='FIXED_LIST_ITEM']" mode="generate-method-update">
	<xsl:param name="var-parent-entity">_entity</xsl:param>
	
	<xsl:variable name="getter-name">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="mapping/entity/getter/@name"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="identifier-getter-name">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="mapping/attribute[@vm-attr='id_id']/getter/@name"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:if test="external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']">
		<xsl:text>&#13;</xsl:text>
		<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
		<xsl:text> o</xsl:text>
		<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
		<xsl:text> = ClassLoader.GetInstance().GetBean&lt;</xsl:text><xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/><xsl:text>&gt;();</xsl:text>
		<xsl:text>if(</xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="$getter-name"/>
		<xsl:text> != null){List&lt;IViewModel&gt; lstVM = o</xsl:text>
		<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
		<xsl:text>.Lst</xsl:text>
		<xsl:value-of select="external-lists/external-list/viewmodel/implements/interface/@name"/>
		<xsl:text>.ListViewModel.ToList();</xsl:text>
	    <xsl:text>foreach(</xsl:text>
	    <xsl:value-of select="external-lists/external-list/viewmodel/type/item"/>
	    <xsl:text> item in lstVM){</xsl:text>
	    <xsl:text> if((item.</xsl:text>
		<xsl:value-of select="identifier/attribute/@name-capitalized"/>
		<xsl:text>.Equals(</xsl:text>
	    <xsl:value-of select="$var-parent-entity"/>
	    <xsl:text>.</xsl:text>
	    <xsl:value-of select="$getter-name"/>
	    <xsl:text>.</xsl:text>
	    <xsl:value-of select="$identifier-getter-name"/>
	    <xsl:text>)))</xsl:text>
	    <xsl:text>{this.Selected</xsl:text>
		<xsl:value-of select="external-lists/external-list/viewmodel/type/item"/>
	    <xsl:text> = item;}&#13;}&#13;}&#13;</xsl:text>
    </xsl:if>
</xsl:template>

<!--  Cas d'une pickerlist -->
<xsl:template match="viewmodel" mode="generate-method-update">
	<xsl:apply-templates select="external-lists/external-list/viewmodel" mode="generate-method-update-for-pickerlist"/>
</xsl:template>


<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-method-update-for-pickerlist">
	<xsl:param name="var-parent-entity">_entity</xsl:param>
	
	<xsl:variable name="selected-entity"><xsl:value-of select="implements/interface/@name"/></xsl:variable>
	
	<xsl:variable name="getter-name">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="../../../mapping/entity[@vm-type=$selected-entity]">
						<xsl:value-of select="../../../mapping/entity[@vm-type=$selected-entity]/getter/@name"/>
					</xsl:when>
					<xsl:when test="../../../mapping/entity/entity[@vm-type=$selected-entity]">
						<xsl:value-of select="../../../mapping/entity/entity[@vm-type=$selected-entity]/../getter/@name"/>
						<xsl:text>.</xsl:text>
						<xsl:call-template name="string-uppercase-firstchar">
							<xsl:with-param name="text">
								<xsl:value-of select="../../../mapping/entity/entity[@vm-type=$selected-entity]/getter/@name"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="identifier-getter-name">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="../../../mapping/attribute[@vm-attr='id_id']/getter/@name"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:text>if(</xsl:text>
	<xsl:value-of select="$var-parent-entity"/>
	<xsl:text>.</xsl:text>
	<xsl:value-of select="$getter-name"/>
	<xsl:text> != null){List&lt;IViewModel&gt; lstVM = this.Lst</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text>.ListViewModel.ToList();</xsl:text>
    <xsl:text>foreach(</xsl:text>
    <xsl:value-of select="type/item"/>
    <xsl:text> item in lstVM){</xsl:text>
    <xsl:text> if(item.</xsl:text>
	<xsl:value-of select="identifier/attribute/@name-capitalized"/>
	<xsl:text>.Equals(</xsl:text>
    <xsl:value-of select="$var-parent-entity"/>
    <xsl:text>.</xsl:text>
	<xsl:value-of select="$getter-name"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="$identifier-getter-name"/>
    <xsl:text>))</xsl:text>
    <xsl:text>{this.Selected</xsl:text>
    <xsl:value-of select="type/item"/>
    <xsl:text> = item;}&#13;}&#13;}&#13;</xsl:text>
</xsl:template>

<xsl:template match="association" mode="generate-method-update">
	<xsl:text>if (_entity.</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text> != null)</xsl:text>
    <xsl:text>{this.IdParent = _entity.</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>.Id;}</xsl:text>
	<xsl:text>&#13;</xsl:text>
</xsl:template>

</xsl:stylesheet>