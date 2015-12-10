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

<xsl:output method="text"/>

<xsl:include href="commons/file-header.xsl"/>
<xsl:include href="commons/imports.xsl"/>
<xsl:include href="commons/non-generated.xsl"/>
<xsl:include href="commons/replace-all.xsl"/>

<xsl:include href="ui/viewmodel/updateFromIdentifiable.xsl"/>
<xsl:include href="ui/viewmodel/clear.xsl"/>

<xsl:template match="viewmodel">

<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="name"/><xsl:text>.cs</xsl:text></xsl:with-param>
</xsl:apply-templates>

<xsl:apply-templates select="." mode="declare-impl-imports"/>
<xsl:call-template name="viewmodel-imports" />

<xsl:text>namespace </xsl:text><xsl:value-of select="./package" /><xsl:text>{</xsl:text>
<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
<xsl:text>/// Class </xsl:text><xsl:value-of select="./name" /><xsl:text>.&#13;</xsl:text>
<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
<xsl:text>public class </xsl:text><xsl:value-of select="./name" /><xsl:text> : AbstractListViewModel&lt;</xsl:text>

<xsl:choose>
	<xsl:when test="type[name='FIXED_LIST']">
		<xsl:value-of select="subvm/viewmodel/name" />
	</xsl:when>
	<xsl:when test="type[name='LIST_1__ONE_SELECTED']">
		<xsl:value-of select="type/item-impl" />
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="subvm/viewmodel/name" />
	</xsl:otherwise>
</xsl:choose>
<xsl:text>&gt; </xsl:text>
<xsl:apply-templates select="implements/interface"	mode="generate-implement-interface" /><xsl:text>{</xsl:text>

<xsl:text>&#13;#region Constructor&#13;&#13;</xsl:text>
<xsl:text>private IViewModelCreator viewModelCreator = ClassLoader.GetInstance().GetBean&lt;IViewModelCreator&gt;();</xsl:text>
<xsl:text>public </xsl:text><xsl:value-of select="./name" /><xsl:text>()</xsl:text><xsl:text>{&#13;</xsl:text>
	<xsl:value-of select="uml-name"/><xsl:text>NavigationDetailCommand = new MDKDelegateCommand(Execute</xsl:text><xsl:value-of select="uml-name"/><xsl:text>NavigationDetail);&#13;</xsl:text>
	<xsl:text>}&#13;</xsl:text>
<xsl:text>&#13;</xsl:text>
 <xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">constructor</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>
<xsl:text>&#13;#endregion&#13;</xsl:text>

<xsl:text>&#13;#region Properties&#13;</xsl:text>

	<xsl:text>public event NavigationRequestHandler </xsl:text><xsl:value-of select="uml-name"/><xsl:text>NavigationDetailRequest;&#13;</xsl:text>
	<xsl:text>protected virtual void On</xsl:text><xsl:value-of select="uml-name"/><xsl:text>NavigationDetailRequest(Object parameter)&#13;</xsl:text>
	<xsl:text>{&#13;</xsl:text><xsl:value-of select="uml-name"/><xsl:text>NavigationDetailRequest(this,parameter);&#13;}&#13;&#13;</xsl:text>

	<xsl:text>/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Command that navigate to the list detail&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>public ICommand </xsl:text><xsl:value-of select="uml-name"/><xsl:text>NavigationDetailCommand&#13;</xsl:text>
	<xsl:text>&#13;{&#13;get;&#13;set;&#13;}&#13;&#13;</xsl:text>

	<xsl:text>&#13;</xsl:text>
 <xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">properties</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>
<xsl:text>&#13;#endregion&#13;</xsl:text>

<xsl:text>&#13;#region Methods&#13;</xsl:text>

<xsl:if test="dataloader-impl">
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public void UpdateFromDataLoader(</xsl:text><xsl:value-of select="dataloader-impl/dataloader-interface/name"/><xsl:text> p_dataloader) {&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">updateFromDataLoader</xsl:with-param>
			<xsl:with-param name="defaultSource">
		<xsl:text>if (p_dataloader == null) {
			base.Clear();
			} else {      
	        base.Clear();
	        &#13;List&lt;</xsl:text><xsl:value-of select="dataloader-impl/dataloader-interface/entity-type/name"/><xsl:text>&gt; data = p_dataloader.GetData();
	        if(data != null){
	        	viewModelCreator.CreateOrUpdate</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>(data);
	        }        
		}&#13;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	<xsl:text>}&#13;</xsl:text>
</xsl:if>

<xsl:if test="not(type/name='LIST_1__ONE_SELECTED')">
<xsl:apply-templates select="." mode="generate-createEmptyItem" />
<xsl:apply-templates select="." mode="generate-DeleteItem" />
</xsl:if>

<xsl:text>public void Execute</xsl:text><xsl:value-of select="uml-name"/><xsl:text>NavigationDetail(object parameter)&#13;{&#13;</xsl:text>
<xsl:text>On</xsl:text><xsl:value-of select="uml-name"/><xsl:text>NavigationDetailRequest(parameter);&#13;</xsl:text>
<xsl:text>}&#13;</xsl:text>

<xsl:text>&#13;</xsl:text>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">methods</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>
<xsl:text>&#13;</xsl:text>

<xsl:text>&#13;#endregion&#13;&#13;</xsl:text>

<xsl:text>}&#13;</xsl:text>
<xsl:text>}&#13;</xsl:text>

</xsl:template>

<xsl:template match="node()" mode="declare-extra-imports">
</xsl:template>

<xsl:template match="viewmodel" mode="defineViewModelName">
	<xsl:text>return @"</xsl:text><xsl:value-of select="subvm/viewmodel/name"/><xsl:text>";&#13;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="defineViewModelName">
	<xsl:text>return @"</xsl:text><xsl:value-of select="name"/><xsl:text>";&#13;</xsl:text>
</xsl:template>

<xsl:template match="interface" mode="generate-implement-interface">
	<xsl:text>, </xsl:text>
	<xsl:value-of select="@name" />
</xsl:template>

		
<xsl:template match="viewmodel" mode="generate-createEmptyItem">
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public override IViewModel CreateEmptyItem()</xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:text>IViewModel result = null;</xsl:text>
       <xsl:text>if (this.WeakMasterViewModel != null) {</xsl:text>
           <xsl:text>this.WeakMasterViewModel.TryGetTarget(out result);</xsl:text>
       <xsl:text>}</xsl:text>
       <xsl:text>return viewModelCreator.CreateOrUpdate</xsl:text>
	<xsl:value-of select="./subvm/viewmodel/implements/interface/@name"/>
       <xsl:text>(null, result);</xsl:text>
	<xsl:text>}&#13;</xsl:text>
</xsl:template>


<xsl:template match="viewmodel" mode="generate-DeleteItem">
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public override void DeleteItem(long id)</xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:text>IViewModel toDelete = null;</xsl:text>
	<xsl:text>foreach (IViewModel vm in this.ListViewModel)</xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:text>if (vm.Id_id == id)</xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:text>toDelete = vm;</xsl:text>
	<xsl:text>}</xsl:text>
	<xsl:text>}</xsl:text>
	<xsl:text>if (toDelete != null) this.ListViewModel.Remove(toDelete);</xsl:text>
	<xsl:text>}&#13;</xsl:text>
</xsl:template>	

</xsl:stylesheet>