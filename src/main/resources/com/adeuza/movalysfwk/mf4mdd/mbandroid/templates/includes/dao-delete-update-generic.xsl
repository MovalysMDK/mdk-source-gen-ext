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

<!-- Permet de générer la suppression ou la mise a jour de la référence vers l'entité maitre-->
<xsl:template name="delete-update-generic">
	<xsl:param name="interface"/>
	<xsl:param name="class"/>
	<xsl:param name="object"/>
	<xsl:param name="traitement-list"/>
	
	<!-- $traitement-list = 'false' and  -->
	<xsl:if test="@type='one-to-many' and (@opposite-aggregate-type = 'COMPOSITE' or @not-null='true')">
		<xsl:variable name="assoDelete" select="."/>
		<xsl:variable name="source"><xsl:if test="$traitement-list = 'true'"><xsl:text> o</xsl:text><xsl:value-of select="$interface/name"/></xsl:if><xsl:if test="$traitement-list = 'false'"><xsl:value-of select="$object"/></xsl:if></xsl:variable>
	
		DaoQuery oDaoQuery = <xsl:text>this.</xsl:text>
		<xsl:if test="@self-ref = 'false'">
			<xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text>
		</xsl:if>
		<xsl:text>getSelectDaoQuery();</xsl:text>
		
		<xsl:for-each select="$class/identifier/descendant::attribute">
		oDaoQuery.getSqlQuery().addToWhere(new SqlEqualsValueCondition(<xsl:value-of select="$assoDelete/dao-interface/name"/>.FK_<xsl:value-of select="$assoDelete/@opposite-cascade-name"/>[<xsl:value-of select="position()-1"/>].getKey(),
		<xsl:value-of select="$source"/>.<xsl:value-of select="get-accessor"/>(),<xsl:value-of select="$assoDelete/dao-interface/name"/>.FK_<xsl:value-of select="$assoDelete/@opposite-cascade-name"/>[<xsl:value-of select="position()-1"/>].getValue()));
		</xsl:for-each>
						
		if ( !<xsl:value-of select="$source"/><xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/><xsl:text>().isEmpty() ) {</xsl:text>
			List&lt;Object&gt; listValues = new ArrayList&lt;Object&gt;();
			for( <xsl:value-of select="interface/name"/> o<xsl:value-of select="interface/name"/>ToAdd : <xsl:value-of select="$source"/><xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/><xsl:text>()) {</xsl:text><xsl:for-each select="descendant::attribute">
				<xsl:if test="parent::association[@type='one-to-many']">listValues.add(o<xsl:value-of select="../interface/name"/>ToAdd.<xsl:value-of select="get-accessor"/>());</xsl:if>
				<xsl:if test="not(parent::association[@type='one-to-many'])">listValues.add(o<xsl:value-of select="../../interface/name"/>ToAdd.<xsl:value-of select="../get-accessor"/>().<xsl:value-of select="get-accessor"/>());</xsl:if></xsl:for-each>
			}
			SqlNotInValueCondition oSqlNotInValueCondition = new SqlNotInValueCondition(<xsl:value-of select="dao-interface/name"/>.PK_FIELDS,listValues);
			oDaoQuery.getSqlQuery().addToWhere(oSqlNotInValueCondition);
		}
		List&lt;<xsl:value-of select="interface/name"/>
		<xsl:text>&gt; listToDelete = this.</xsl:text>
		<xsl:if test="@self-ref = 'false'">
			<xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text>
		</xsl:if>
		<xsl:text>getList</xsl:text><xsl:value-of select="interface/name"/>
		<xsl:text>( oDaoQuery, this.</xsl:text>
		<xsl:if test="@self-ref = 'false'">
			<xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text>
		</xsl:if>getDeleteCascade(), p_oContext);
		if ( !listToDelete.isEmpty()) {
			<xsl:text>this.</xsl:text>
			<xsl:if test="@self-ref = 'false'">
				<xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text>
			</xsl:if>
			<xsl:text>deleteList</xsl:text>
			<xsl:value-of select="interface/name"/>
			<xsl:text>(listToDelete, this.</xsl:text>
			<xsl:if test="@self-ref = 'false'">
				<xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text>
			</xsl:if>
			<xsl:text>getDeleteCascade(), p_oContext);</xsl:text>
		}
	</xsl:if>
	
	<!-- 
	<xsl:if test="@type='one-to-many' and @not-null='true' and @opposite-aggregate-type != 'COMPOSITE'">
		<xsl:variable name="assoDelete" select="."/>
		<xsl:variable name="source"><xsl:if test="$traitement-list = 'true'"><xsl:text> o</xsl:text><xsl:value-of select="$interface/name"/></xsl:if><xsl:if test="$traitement-list = 'false'"><xsl:value-of select="$object"/></xsl:if></xsl:variable>
	
		SqlDelete oSqlDelete = new SqlDelete(<xsl:value-of select="dao-interface/name"/>.TABLE_NAME);<xsl:for-each select="$class/identifier/descendant::attribute">
		oSqlDelete.addToWhere(new SqlEqualsValueCondition(<xsl:value-of select="$assoDelete/dao-interface/name"/>.FK_<xsl:value-of select="$assoDelete/@opposite-cascade-name"/>[<xsl:value-of select="position()-1"/>].getKey(),
			<xsl:value-of select="$source"/>.<xsl:value-of select="get-accessor"/>(),<xsl:value-of select="$assoDelete/dao-interface/name"/>.FK_<xsl:value-of select="$assoDelete/@opposite-cascade-name"/>[<xsl:value-of select="position()-1"/>].getValue()));</xsl:for-each>
		if ( !<xsl:value-of select="$source"/><xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/><xsl:text>().isEmpty() ) {</xsl:text>
			List&lt;Object&gt; listValues = new ArrayList&lt;Object&gt;();
			for( <xsl:value-of select="interface/name"/> o<xsl:value-of select="interface/name"/>ToAdd : <xsl:value-of select="$source"/><xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/><xsl:text>()) {</xsl:text><xsl:for-each select="descendant::attribute">
				<xsl:if test="parent::association[@type='one-to-many']">listValues.add(o<xsl:value-of select="../interface/name"/>ToAdd.<xsl:value-of select="get-accessor"/>());</xsl:if>
				<xsl:if test="not(parent::association[@type='one-to-many'])">listValues.add(o<xsl:value-of select="../../interface/name"/>ToAdd.<xsl:value-of select="../get-accessor"/>().<xsl:value-of select="get-accessor"/>());</xsl:if></xsl:for-each>
			}
			SqlNotInValueCondition oSqlNotInValueCondition = new SqlNotInValueCondition(<xsl:value-of select="dao-interface/name"/>.PK_FIELDS,listValues);
			oSqlDelete.addToWhere(oSqlNotInValueCondition);
		}
		<xsl:text>this.</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text></xsl:if><xsl:text>genericDelete(oSqlDelete,p_oContext);</xsl:text>
	</xsl:if>
	 -->
	
	<xsl:if test="@type='one-to-many' and @not-null='false' and @opposite-aggregate-type != 'COMPOSITE'">
		<xsl:variable name="assoDelete" select="."/>
		<xsl:variable name="source"><xsl:if test="$traitement-list = 'true'"><xsl:text> o</xsl:text><xsl:value-of select="$interface/name"/></xsl:if><xsl:if test="$traitement-list = 'false'"><xsl:value-of select="$object"/></xsl:if></xsl:variable>
		
		SqlUpdate oListSqlUpdate = new SqlUpdate(<xsl:value-of select="dao-interface/name"/>.TABLE_NAME);<xsl:for-each select="$class/identifier/descendant::attribute">
		oListSqlUpdate.addBindedField(<xsl:value-of select="$assoDelete/dao-interface/name"/>.FK_<xsl:value-of select="$assoDelete/@opposite-cascade-name"/>[<xsl:value-of select="position()-1"/>].getKey());
		SqlEqualsValueCondition oSqlEqualsValueCondition<xsl:value-of select="position()-1"/> = new SqlEqualsValueCondition(<xsl:value-of select="$assoDelete/dao-interface/name"/>.FK_<xsl:value-of select="$assoDelete/@opposite-cascade-name"/>[<xsl:value-of select="position()-1"/>].getKey(),
			<xsl:value-of select="$source"/>.<xsl:value-of select="get-accessor"/>(),<xsl:value-of select="$assoDelete/dao-interface/name"/>.FK_<xsl:value-of select="$assoDelete/@opposite-cascade-name"/>[<xsl:value-of select="position()-1"/>].getValue());
		oListSqlUpdate.addToWhere(oSqlEqualsValueCondition<xsl:value-of select="position()-1"/>);</xsl:for-each>
		List&lt;Object&gt; listValues = new ArrayList&lt;Object&gt;();
		SqlNotInValueCondition oSqlNotInValueCondition = new SqlNotInValueCondition(<xsl:value-of select="dao-interface/name"/>.PK_FIELDS,listValues);
		if ( !<xsl:value-of select="$source"/><xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/><xsl:text>().isEmpty() ) {</xsl:text>
			for( <xsl:value-of select="interface/name"/> o<xsl:value-of select="interface/name"/>ToAdd : <xsl:value-of select="$source"/><xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/><xsl:text>()) {</xsl:text><xsl:for-each select="descendant::attribute">
				<xsl:if test="parent::association[@type='one-to-many']">listValues.add(o<xsl:value-of select="../interface/name"/>ToAdd.<xsl:value-of select="get-accessor"/>());</xsl:if>
				<xsl:if test="not(parent::association[@type='one-to-many'])">listValues.add(o<xsl:value-of select="../../interface/name"/>ToAdd.<xsl:value-of select="../get-accessor"/>().<xsl:value-of select="get-accessor"/>());</xsl:if></xsl:for-each>
			}
			oListSqlUpdate.addToWhere(oSqlNotInValueCondition);
		}
		Connection oConnection = ((MContextImpl) p_oContext).getTransaction().getConnection();
		PreparedStatement oStatement = oConnection.prepareStatement(oListSqlUpdate.toSql(p_oContext));
		try {
			StatementBinder oBinder = new StatementBinder(oStatement);
			<xsl:for-each select="$class/identifier/descendant::attribute">
			<xsl:text>oBinder.bindNull(SqlType.</xsl:text><xsl:value-of select="jdbc-type"/>);
			</xsl:for-each>
			<xsl:for-each select="$class/identifier/descendant::attribute">
			<xsl:text>oSqlEqualsValueCondition</xsl:text><xsl:value-of select="position()-1"/>.bindValues(oBinder);
			</xsl:for-each>
			oSqlNotInValueCondition.bindValues(oBinder);
			oStatement.executeUpdate();
		} finally {
			oStatement.close();
		}
	</xsl:if>

</xsl:template>

</xsl:stylesheet>

