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

<!-- Méthode de sauvegarde avec les valeurs en paramètre -->
<xsl:template name="dao-joinclass-interface">
	<xsl:variable name="interface" select="dao/interface"/>
	<xsl:variable name="class" select="dao/class"/>

	/**
	 * Sauvegarde l'entité <xsl:value-of select="$interface/name"/> avec les paramètres de la clé primaire.
	 * <xsl:for-each select="$class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:text>public void save</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
	<xsl:for-each select="$class/identifier/descendant::attribute">
		<xsl:value-of select="@type-short-name"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="parameter-name"/>
		<xsl:if test="position() != last()">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:for-each>
	<xsl:text>, ItfTransactionalContext p_oContext ) throws DaoException ;</xsl:text>
</xsl:template>

<xsl:template name="dao-joinclass">
	<xsl:param name="interface"/>
	<xsl:param name="class"/>
	
	/**
	 * Sauvegarde l'entité <xsl:value-of select="$interface/name"/> avec les paramètres de la clé primaire.
	 * <xsl:for-each select="$class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:text>public void save</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
	<xsl:for-each select="$class/identifier/descendant::attribute">
		<xsl:value-of select="@type-short-name"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="parameter-name"/>
		<xsl:if test="position() != last()">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:for-each>
	<xsl:text>, ItfTransactionalContext p_oContext ) throws DaoException {
		</xsl:text>
				
		try {	
			SqlInsert oSqlInsert = this.getInsertQuery();
			Connection oConnection = ((ContextImpl)p_oContext).getTransaction().getJDBCConnection();
			PreparedStatement oStatement = oConnection.prepareStatement(oSqlInsert.toSql(p_oContext));
			try {
				StatementBinder oStatementBinder = new StatementBinder(oStatement);
				<xsl:for-each select="$class/identifier/descendant::attribute">
					<xsl:call-template name="jdbc-bind-insert">
						<xsl:with-param name="interface" select="$interface"/>
						<xsl:with-param name="statement">oStatementBinder</xsl:with-param>
						<xsl:with-param name="object"><xsl:value-of select="parameter-name"/></xsl:with-param>
						<xsl:with-param name="by-value">true</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>			
				oStatement.executeUpdate();
			} finally {
				oStatement.close();			
			}
			
		} catch( SQLException e ) {
			throw new DaoException(e);
		}
	}

</xsl:template>

<!-- Méthode de sauvegarde à partir de la classe de gauche -->
<xsl:template name="dao-joinclass-insertfromside-interface">
	<xsl:param name="interface"/>
	<xsl:param name="joinclass"/>
	<xsl:param name="class1"/>
	<xsl:param name="class2"/>
	<xsl:param name="asso1"/>
	<xsl:param name="asso2"/>	
	<xsl:param name="masterclass"/>
	
	/**
	 * Sauvegarde l'entité <xsl:value-of select="$interface/name"/>. 
	 *
	 * @param <xsl:text>p_</xsl:text><xsl:value-of select="$asso1/variable-name"/> une entité <xsl:value-of select="$class1/implements/interface/@name"/>
	 * @param <xsl:value-of select="$asso2/parameter-name"/> une liste d'entité <xsl:value-of select="$class2/implements/interface/@name"/>
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:text>public void </xsl:text><xsl:value-of select="$asso2/method-name"/>
	<xsl:text>(</xsl:text>
	<xsl:value-of select="$class1/implements/interface/@name"/>
	<xsl:text> p_</xsl:text>
	<xsl:value-of select="$asso1/variable-name"/>
	<xsl:text>, BOList&lt;</xsl:text>
	<xsl:value-of select="$class2/implements/interface/@name"/>
	<xsl:text>&gt; </xsl:text>
	<xsl:value-of select="$asso2/parameter-name"/>
	<xsl:text>, ItfTransactionalContext p_oContext ) throws DaoException ;</xsl:text>
	
	/**
	 * Sauvegarde l'entité <xsl:value-of select="$interface/name"/>. 
	 *
	 * @param <xsl:text>p_</xsl:text><xsl:value-of select="$asso1/variable-name"/> une entité <xsl:value-of select="$class1/implements/interface/@name"/>
	 * @param <xsl:value-of select="$asso2/parameter-name"/> une liste d'entité <xsl:value-of select="$class2/implements/interface/@name"/>
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:text>public void </xsl:text><xsl:value-of select="$asso2/method-name"/>
	<xsl:text>(</xsl:text>
	<xsl:value-of select="$class1/implements/interface/@name"/>
	<xsl:text> p_</xsl:text>
	<xsl:value-of select="$asso1/variable-name"/>
	<xsl:text>, BOList&lt;</xsl:text>
	<xsl:value-of select="$class2/implements/interface/@name"/>
	<xsl:text>&gt; </xsl:text>
	<xsl:value-of select="$asso2/parameter-name"/>
	<xsl:text>, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException ;</xsl:text>
</xsl:template>

<xsl:template name="dao-joinclass-insertfromside">
	<xsl:param name="interface"/>
	<xsl:param name="joinclass"/>
	<xsl:param name="class1"/>
	<xsl:param name="class2"/>
	<xsl:param name="asso1"/>
	<xsl:param name="asso2"/>	
	<xsl:param name="masterclass"/>

	/**
	 * Sauvegarde l'entité <xsl:value-of select="$interface/name"/>. 
	 *
	 * @param <xsl:text>p_</xsl:text><xsl:value-of select="$asso1/variable-name"/> une entité <xsl:value-of select="$class1/implements/interface/@name"/>
	 * @param <xsl:value-of select="$asso2/parameter-name"/> une liste d'entité <xsl:value-of select="$class2/implements/interface/@name"/>
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:text>public void </xsl:text><xsl:value-of select="$asso2/method-name"/>
	<xsl:text>(</xsl:text>
	<xsl:value-of select="$class1/implements/interface/@name"/>
	<xsl:text> p_</xsl:text>
	<xsl:value-of select="$asso1/variable-name"/>
	<xsl:text>, BOList&lt;</xsl:text>
	<xsl:value-of select="$class2/implements/interface/@name"/>
	<xsl:text>&gt; </xsl:text>
	<xsl:value-of select="$asso2/parameter-name"/>
	<xsl:text>, ItfTransactionalContext p_oContext ) throws DaoException {
		this.</xsl:text><xsl:value-of select="$asso2/method-name"/><xsl:text>(</xsl:text>
		<xsl:text> p_</xsl:text><xsl:value-of select="$asso1/variable-name"/><xsl:text>, </xsl:text><xsl:value-of select="$asso2/parameter-name"/>
		<xsl:text>, new DaoSession(), p_oContext );
	}</xsl:text>

	/**
	 * Sauvegarde l'entité <xsl:value-of select="$interface/name"/>. 
	 *
	 * @param <xsl:text>p_</xsl:text><xsl:value-of select="$asso1/variable-name"/> une entité <xsl:value-of select="$class1/implements/interface/@name"/>
	 * @param <xsl:value-of select="$asso2/parameter-name"/> une liste d'entité <xsl:value-of select="$class2/implements/interface/@name"/>
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:text>public void </xsl:text><xsl:value-of select="$asso2/method-name"/>
	<xsl:text>(</xsl:text>
	<xsl:value-of select="$class1/implements/interface/@name"/>
	<xsl:text> p_</xsl:text>
	<xsl:value-of select="$asso1/variable-name"/>
	<xsl:text>, BOList&lt;</xsl:text>
	<xsl:value-of select="$class2/implements/interface/@name"/>
	<xsl:text>&gt; </xsl:text>
	<xsl:value-of select="$asso2/parameter-name"/>
	<xsl:text>, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException {</xsl:text>

		BOList&lt;<xsl:value-of select="$interface/name"/>
		<xsl:text>&gt; listNew</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text> = new BOListImpl&lt;</xsl:text>
		<xsl:value-of select="$interface/name"/>&gt;();
		<xsl:text>for (</xsl:text>
		<xsl:value-of select="$class2/implements/interface/@name"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$asso2/variable-name"/>
		<xsl:text> : </xsl:text>
		<xsl:value-of select="$asso2/parameter-name"/>
		<xsl:text> ) {</xsl:text>
			<xsl:value-of select="$interface/name"/><xsl:text> </xsl:text><xsl:value-of select="$asso1/variable-name"/> = this.<xsl:value-of select="class/pojo-factory-interface/bean-name"/>.createInstanceNoChangeRecord();
		
			<!-- paramètre du constructor, ordre à respecter -->
			<xsl:if test="$masterclass = $class1">
				<xsl:for-each select="$class1/identifier/descendant::attribute">
					<xsl:variable name="pos" select="position()"/>
					<xsl:value-of select="$asso1/variable-name"/>.<xsl:value-of select="$joinclass/identifier/descendant::attribute[position() = $pos]/set-accessor"/>(p_<xsl:value-of select="$asso1/variable-name"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="get-accessor"/>
					<xsl:text>());</xsl:text>
				</xsl:for-each>
				
				<xsl:for-each select="$class2/identifier/descendant::attribute">
					<xsl:variable name="countAttrClass1" select="count($class1/identifier/descendant::attribute)"/>
					<xsl:variable name="pos" select="position() + $countAttrClass1"/>
					<xsl:value-of select="$asso1/variable-name"/>.<xsl:value-of select="$joinclass/identifier/descendant::attribute[position() = $pos]/set-accessor"/>(<xsl:value-of select="$asso2/variable-name"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="get-accessor"/>
					<xsl:text>());</xsl:text>
				</xsl:for-each>
			</xsl:if>		
		
			<xsl:if test="$masterclass = $class2 and $masterclass != $class1">
				<xsl:for-each select="$class2/identifier/descendant::attribute">
					<xsl:variable name="pos" select="position()"/>
					<xsl:value-of select="$asso1/variable-name"/>.<xsl:value-of select="$joinclass/identifier/descendant::attribute[position() = $pos]/set-accessor"/>(<xsl:value-of select="$asso2/variable-name"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="get-accessor"/>
					<xsl:text>());</xsl:text>
				</xsl:for-each>			
			
				<xsl:for-each select="$class1/identifier/descendant::attribute">
					<xsl:variable name="countAttrClass1" select="count($class2/identifier/descendant::attribute)"/>
					<xsl:variable name="pos" select="position() + $countAttrClass1"/>				
					<xsl:value-of select="$asso1/variable-name"/>.<xsl:value-of select="$joinclass/identifier/descendant::attribute[position() = $pos]/set-accessor"/>(p_<xsl:value-of select="$asso1/variable-name"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="get-accessor"/>
					<xsl:text>());</xsl:text>
				</xsl:for-each>			
			</xsl:if>		
		
			listNew<xsl:value-of select="$interface/name"/>
			<xsl:text>.add(</xsl:text>
			<xsl:value-of select="$asso1/variable-name"/>
			<xsl:text>);</xsl:text> 
		}

		BOList&lt;<xsl:value-of select="$interface/name"/>
		<xsl:text>&gt; listOld</xsl:text><xsl:value-of select="$interface/name"/>
		<xsl:text> = getList</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text>By</xsl:text>
		
		<xsl:if test="$masterclass = $class1">
		<xsl:for-each select="$class1/identifier/descendant::attribute">
			<xsl:variable name="pos" select="position()"/>
			<xsl:value-of select="$joinclass/identifier/descendant::attribute[position() = $pos]/method-crit-name"/>
			<xsl:if test="position() != last()">
				<xsl:text>And</xsl:text>
			</xsl:if>
		</xsl:for-each>
		</xsl:if>
		
		<xsl:if test="$masterclass = $class2 and $masterclass != $class1">
		<xsl:for-each select="$class1/identifier/descendant::attribute">
			<xsl:variable name="countAttrClass1" select="count($class1/identifier/descendant::attribute)"/>
			<xsl:variable name="pos" select="position() + $countAttrClass1"/>
			<xsl:value-of select="$joinclass/identifier/descendant::attribute[position() = $pos ]/method-crit-name"/>
			<xsl:if test="position() != last()">
				<xsl:text>_</xsl:text>
			</xsl:if>
		</xsl:for-each>
		</xsl:if>
		
		
		<xsl:text>( </xsl:text>
		<xsl:for-each select="$class1/identifier/descendant::attribute">
			<xsl:text>p_</xsl:text>
			<xsl:value-of select="$asso1/variable-name"/>
			<xsl:text>.</xsl:text>
			<xsl:value-of select="get-accessor"/>
			<xsl:text>()</xsl:text>
			<xsl:if test="position() != last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>, CascadeSet.NONE, new DaoSession(), p_oContext);</xsl:text>

		BOList&lt;<xsl:value-of select="$interface/name"/>
		<xsl:text>&gt; listToDelete = new BOListImpl&lt;</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text>&gt;(BOListImpl.subtract(listOld</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text>, listNew</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text> ));</xsl:text>
		BOList&lt;<xsl:value-of select="$interface/name"/>
		<xsl:text>&gt; listToAdd = new BOListImpl&lt;</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text>&gt;(BOListImpl.subtract(listNew</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text>, listOld</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text> ));</xsl:text>
		
		if ( !listToAdd.isEmpty() ) {
			this.saveList<xsl:value-of select="$interface/name"/>( listToAdd, CascadeSet.NONE, p_oContext );
		}
		if ( !listToDelete.isEmpty() ) {
			this.deleteList<xsl:value-of select="$interface/name"/>( listToDelete, CascadeSet.NONE, p_oContext );
		}
	}
</xsl:template>


<xsl:template name="dao-joinclass-fk">
	<xsl:param name="interface"/>
	<xsl:param name="class"/>

	<xsl:variable name="assoLeftName" select="$class/left-association/name"/>
	<xsl:variable name="assoRightName" select="$class/right-association/name"/>
	<xsl:variable name="rightClass" select="right-class"/>
	<xsl:variable name="leftClass" select="left-class"/>

	<xsl:variable name="assoOwner" select="$rightClass/association[@name = $assoRightName and @relation-owner = 'true' ]
		| $leftClass/association[@name = $assoLeftName and @relation-owner = 'true' ]"/>

	public static final PairValue&lt;Field,SqlType&gt;[] FK_<xsl:value-of select="$assoOwner/@cascade-name"/>
		<xsl:text> = new PairValue[] {</xsl:text>
		<xsl:for-each select="$assoOwner/join-table/crit-fields/field">
			new PairValue&lt;Field,SqlType&gt;( <xsl:value-of select="$interface/name"/>Field.<xsl:value-of select="@name"/>
			<xsl:text>, SqlType.</xsl:text><xsl:value-of select="@jdbc-type"/>
			<xsl:text>)</xsl:text>
			<xsl:if test="position() != last()">
				<xsl:text>,
				</xsl:text>
			</xsl:if>			
		</xsl:for-each>
	<xsl:text>};</xsl:text>
		
	public static final PairValue&lt;Field,SqlType&gt;[] FK_<xsl:value-of select="$assoOwner/@opposite-cascade-name"/>
		<xsl:text> = new PairValue[] {</xsl:text>		
		<xsl:for-each select="$assoOwner/join-table/key-fields/field">			
			new PairValue&lt;Field,SqlType&gt;( <xsl:value-of select="$interface/name"/>Field.<xsl:value-of select="@name"/>
			<xsl:text>, SqlType.</xsl:text><xsl:value-of select="@jdbc-type"/>
			<xsl:text>)</xsl:text>
			<xsl:if test="position() != last()">
				<xsl:text>,
				</xsl:text>
			</xsl:if>
		</xsl:for-each>
	<xsl:text>};</xsl:text>

<!-- 
	/**
	 * Join to use from class 
	 */
	public static final InnerJoin INNERJOIN_<xsl:value-of select="$assoOwner/@opposite-cascade-name"/> ;
	
    /**
	 * Join to use from class 
	 */
	public static final InnerJoin INNERJOIN_<xsl:value-of select="$assoOwner/@cascade-name"/> ;

	static {
		List&lt;PairValue&lt;Field,Field&gt;&gt; listJoinOnFields = new ArrayList&lt;PairValue&lt;Field,Field&gt;&gt;();
		<xsl:for-each select="$assoOwner/join-table/crit-fields/field">
		<xsl:text>listJoinOnFields.add( new PairValue&lt;Field, Field&gt;(</xsl:text>
		<xsl:value-of select="$assoOwner/opposite-dao-interface/name"/>
		<xsl:text>.PK_FIELDS[</xsl:text>
		<xsl:value-of select="position() -1 "/>
		<xsl:text>].getKey(),</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text>Field.</xsl:text><xsl:value-of select="@name"/>
		<xsl:text>));</xsl:text>
		</xsl:for-each>
		INNERJOIN_<xsl:value-of select="$assoOwner/@opposite-cascade-name"/>
		<xsl:text> = new InnerJoin(</xsl:text>
		<xsl:value-of select="$assoOwner/opposite-dao-interface/name"/>
		<xsl:text>.TABLE_NAME, TABLE_NAME, listJoinOnFields );</xsl:text>
		
		listJoinOnFields = new ArrayList&lt;PairValue&lt;Field,Field&gt;&gt;();
		<xsl:for-each select="$assoOwner/join-table/key-fields/field">
		<xsl:text>listJoinOnFields.add( new PairValue&lt;Field, Field&gt;(</xsl:text>
		<xsl:value-of select="$assoOwner/dao-interface/name"/>
		<xsl:text>.PK_FIELDS[</xsl:text>
		<xsl:value-of select="position() -1 "/>
		<xsl:text>].getKey(),</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text>Field.</xsl:text><xsl:value-of select="@name"/>
		<xsl:text>));</xsl:text>		
		</xsl:for-each>
		INNERJOIN_<xsl:value-of select="$assoOwner/@cascade-name"/>
		<xsl:text> = new InnerJoin(</xsl:text>
		<xsl:value-of select="$assoOwner/dao-interface/name"/>
		<xsl:text>.TABLE_NAME, TABLE_NAME, listJoinOnFields );</xsl:text>
	}
 -->
 
</xsl:template>

<xsl:template name="dao-joinclass-fk-2">
	<xsl:param name="dao"/>

	<xsl:variable name="assoLeftName" select="$dao/class/left-association/name"/>
	<xsl:variable name="assoRightName" select="$dao/class/right-association/name"/>
	<xsl:variable name="rightClass" select="$dao/right-class"/>
	<xsl:variable name="leftClass" select="$dao/left-class"/>

	<xsl:variable name="assoOwner" select="$rightClass/association[@name = $assoRightName and @relation-owner = 'true' ]
		| $leftClass/association[@name = $assoLeftName and @relation-owner = 'true' ]"/>

	/**
	 * Tableau de clés étrangères pour l'association
	 */
	public static final PairValue&lt;Field,SqlType&gt;[] FK_<xsl:value-of select="$assoOwner/@cascade-name"/> = new PairValue[] {<xsl:for-each select="$assoOwner/join-table/crit-fields/field">
			new PairValue&lt;Field,SqlType&gt;( <xsl:value-of select="$dao/interface/name"/>Field.<xsl:value-of select="@name"/>
			<xsl:text>, SqlType.</xsl:text><xsl:value-of select="@jdbc-type"/><xsl:text>)</xsl:text>
			<xsl:if test="position() != last()"><xsl:text>,
			</xsl:text></xsl:if></xsl:for-each><xsl:text>
	};</xsl:text>

	/**
	 * Tableau de clés étrangères pour l'association
	 */
	 public static final PairValue&lt;Field,SqlType&gt;[] FK_<xsl:value-of select="$assoOwner/@opposite-cascade-name"/> = new PairValue[] {<xsl:for-each select="$assoOwner/join-table/key-fields/field">			
			new PairValue&lt;Field,SqlType&gt;( <xsl:value-of select="$dao/interface/name"/>Field.<xsl:value-of select="@name"/>
			<xsl:text>, SqlType.</xsl:text><xsl:value-of select="@jdbc-type"/>
			<xsl:text>)</xsl:text>
			<xsl:if test="position() != last()">
				<xsl:text>,
				</xsl:text>
			</xsl:if>
		</xsl:for-each>
	<xsl:text>};</xsl:text>

	<!-- 
	/**
	 * Join to use from class 
	 */
	@SuppressWarnings("serial")
	public static final InnerJoin INNERJOIN_<xsl:value-of select="$assoOwner/@opposite-cascade-name"/> = new InnerJoin(
		<xsl:value-of select="$assoOwner/opposite-dao-interface/name"/><xsl:text>.TABLE_NAME, TABLE_NAME,</xsl:text>
		new ArrayList&lt;PairValue&lt;Field,Field&gt;&gt;() { {
	<xsl:for-each select="$assoOwner/join-table/crit-fields/field">
		<xsl:text>add( new PairValue&lt;Field, Field&gt;(</xsl:text><xsl:value-of select="$assoOwner/opposite-dao-interface/name"/><xsl:text>.PK_FIELDS[</xsl:text>
		<xsl:value-of select="position() -1 "/><xsl:text>].getKey(),</xsl:text><xsl:value-of select="$dao/interface/name"/><xsl:text>Field.</xsl:text><xsl:value-of select="@name"/>
		<xsl:text>));</xsl:text>
	</xsl:for-each>
	} });

    /**
	 * Join to use from class 
	 */
	@SuppressWarnings("serial")
	public static final InnerJoin INNERJOIN_<xsl:value-of select="$assoOwner/@cascade-name"/> = new InnerJoin(
		<xsl:value-of select="$assoOwner/dao-interface/name"/><xsl:text>.TABLE_NAME, TABLE_NAME,</xsl:text>
		new ArrayList&lt;PairValue&lt;Field,Field&gt;&gt;() { {
	<xsl:for-each select="$assoOwner/join-table/key-fields/field">
		<xsl:text>add( new PairValue&lt;Field, Field&gt;(</xsl:text><xsl:value-of select="$assoOwner/dao-interface/name"/><xsl:text>.PK_FIELDS[</xsl:text>
		<xsl:value-of select="position() -1 "/><xsl:text>].getKey(),</xsl:text><xsl:value-of select="$dao/interface/name"/><xsl:text>Field.</xsl:text><xsl:value-of select="@name"/>
		<xsl:text>));</xsl:text>		
	</xsl:for-each>
	} });
 -->
</xsl:template>


</xsl:stylesheet>